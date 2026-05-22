#if canImport(SwiftUI)
import XCTest
import SwiftUI
@testable import Dirk

final class StateInjectTests: XCTestCase {

    override func tearDown() {
        try! Dirk.stop()
    }

    func test_stateInject_resolvesTheValueFromDirk() throws {
        let model = Model()
        try Dirk.start {
            Module {
                Singleton { model }
            }
        }

        let host = Host()

        XCTAssertTrue(host.viewModel === model)
    }

    func test_stateInject_returnsTheSameInstanceAcrossAccesses() throws {
        try Dirk.start {
            Module {
                Factory { Model() }
            }
        }

        let host = Host()

        // Even with a `Factory` provider, the lazy initializer means the wrapper resolves once and
        // caches the value — same instance on every read of `host.viewModel`.
        XCTAssertTrue(host.viewModel === host.viewModel)
    }


    // MARK: - Static Members/Types

    final class Model: ObservableObject {

        @Published var value: Int = 0
    }

    struct Host {

        @StateInject var viewModel: Model
    }
}
#endif
