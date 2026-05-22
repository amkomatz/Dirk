import XCTest
@testable import Dirk

final class ResolveTests: XCTestCase {

    override func tearDown() {
        try! Dirk.stop()
    }

    func test_resolve_withFactory_returnsAFreshInstanceOnEveryAccess() throws {
        try Dirk.start {
            Module {
                Factory { Object() }
            }
        }

        let host = Host<Object>()

        XCTAssertFalse(host.value === host.value)
    }

    func test_resolve_withSingleton_returnsTheSameInstanceOnEveryAccess() throws {
        try Dirk.start {
            Module {
                Singleton { Object() }
            }
        }

        let host = Host<Object>()

        XCTAssertTrue(host.value === host.value)
    }

    func test_resolve_doesNotResolveBeforeFirstAccess() throws {
        // The host is constructed before Dirk is started. `Resolve` must not eagerly resolve in
        // its initializer, or this test will crash.
        let host = Host<Object>()
        let object = Object()
        try Dirk.start {
            Module {
                Singleton { object }
            }
        }

        XCTAssertTrue(host.value === object)
    }

    func test_resolve_canProvideAClassForAProtocol() throws {
        let object = Object()
        try Dirk.start {
            Module {
                Factory(Interface.self) { object }
            }
        }

        let host = Host<Interface>()

        XCTAssertTrue(host.value === object)
    }


    // MARK: - Static Members/Types

    static var allTests = [
        ("test_resolve_withFactory_returnsAFreshInstanceOnEveryAccess", test_resolve_withFactory_returnsAFreshInstanceOnEveryAccess),
        ("test_resolve_withSingleton_returnsTheSameInstanceOnEveryAccess", test_resolve_withSingleton_returnsTheSameInstanceOnEveryAccess),
        ("test_resolve_doesNotResolveBeforeFirstAccess", test_resolve_doesNotResolveBeforeFirstAccess),
        ("test_resolve_canProvideAClassForAProtocol", test_resolve_canProvideAClassForAProtocol),
    ]

    private class Object: Interface {}

    private struct Host<T> {

        @Resolve
        var value: T
    }
}

private protocol Interface: AnyObject {}
