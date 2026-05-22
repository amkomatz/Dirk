#if canImport(Combine)
import XCTest
import Combine
@testable import Dirk

final class ObservableChildTests: XCTestCase {

    func test_observableChild_exposesTheValuePassedAtInit() {
        let child = Child()
        let parent = Parent(child: child)

        XCTAssertTrue(parent.child === child)
    }

    func test_observableChild_forwardsChildChangesToParent() {
        let parent = Parent(child: Child())
        var parentChangeCount = 0
        let cancellable = parent.objectWillChange.sink { _ in
            parentChangeCount += 1
        }

        // First read activates the subscription.
        parent.child.value = 1
        parent.child.value = 2
        parent.child.value = 3

        XCTAssertEqual(parentChangeCount, 3)
        _ = cancellable
    }

    func test_observableChild_doesNotRetainItsParent() {
        var parent: Parent? = Parent(child: Child())
        weak var weakParent = parent

        parent?.child.value = 42

        parent = nil

        XCTAssertNil(weakParent, "ObservableChild must not retain its enclosing instance")
    }

    func test_observableChild_holdsSeparateChildrenForSeparateProperties() {
        let parent = MultiChildParent(first: Child(), second: Child())
        var parentChangeCount = 0
        let cancellable = parent.objectWillChange.sink { _ in
            parentChangeCount += 1
        }

        parent.first.value = 1
        parent.second.value = 2

        XCTAssertEqual(parentChangeCount, 2)
        XCTAssertFalse(parent.first === parent.second)
        _ = cancellable
    }


    // MARK: - Static Members/Types

    final class Child: ObservableObject {

        @Published var value: Int = 0
    }

    final class Parent: ObservableObject {

        @ObservableChild var child: Child

        init(child: Child) {
            self._child = ObservableChild(wrappedValue: child)
        }
    }

    final class MultiChildParent: ObservableObject {

        @ObservableChild var first: Child
        @ObservableChild var second: Child

        init(first: Child, second: Child) {
            self._first = ObservableChild(wrappedValue: first)
            self._second = ObservableChild(wrappedValue: second)
        }
    }
}
#endif
