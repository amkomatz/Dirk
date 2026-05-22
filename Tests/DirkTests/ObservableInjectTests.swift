#if canImport(Combine)
import XCTest
import Combine
@testable import Dirk

final class ObservableInjectTests: XCTestCase {

    override func tearDown() {
        try! Dirk.stop()
    }

    func test_observableInject_resolvesTheChildFromDirk() throws {
        let child = Child()
        try Dirk.start {
            Module {
                Singleton { child }
            }
        }

        let parent = Parent()

        XCTAssertTrue(parent.child === child)
    }

    func test_observableInject_forwardsChildChangesToParent() throws {
        try Dirk.start {
            Module {
                Singleton { Child() }
            }
        }

        let parent = Parent()
        var parentChangeCount = 0
        let cancellable = parent.objectWillChange.sink { _ in
            parentChangeCount += 1
        }

        // Touching `parent.child` activates the subscription. Without this read, the wrapper has
        // no opportunity to subscribe to the child.
        parent.child.value = 1
        parent.child.value = 2
        parent.child.value = 3

        XCTAssertEqual(parentChangeCount, 3)
        _ = cancellable
    }

    func test_observableInject_doesNotRetainItsParent() throws {
        try Dirk.start {
            Module {
                Singleton { Child() }
            }
        }

        var parent: Parent? = Parent()
        weak var weakParent = parent

        // Activate the subscription so the wrapper holds whatever it needs to hold.
        parent?.child.value = 42

        parent = nil

        XCTAssertNil(weakParent, "ObservableInject must not retain its enclosing instance")
    }


    // MARK: - Static Members/Types

    final class Child: ObservableObject {

        @Published var value: Int = 0
    }

    final class Parent: ObservableObject {

        @ObservableInject var child: Child
    }
}
#endif
