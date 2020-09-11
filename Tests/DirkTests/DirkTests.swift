import XCTest
@testable import Dirk

final class DirkTests: XCTestCase {
    
    override func tearDown() {
        try! Dirk.stop()
    }
    
    func test_factoryProvidesANewInstanceEachTimeCalled() throws {
        try Dirk.start {
            Module {
                Factory { Object() }
            }
        }
        
        let dirk = try Dirk.get()
        let controller1 = try dirk.get(Object.self)
        let controller2 = try dirk.get(Object.self)
        
        XCTAssertFalse(controller1 === controller2)
    }
    
    func test_singletonProvidesTheSameInstanceEachTimeCalled() throws {
        try Dirk.start {
            Module {
                Singleton { Object() }
            }
        }
        
        let dirk = try Dirk.get()
        let controller1 = try dirk.get(Object.self)
        let controller2 = try dirk.get(Object.self)
        
        XCTAssertTrue(controller1 === controller2)
    }
    
    func test_multipleFactoriesProvidingTheSameType_usesTheLastProvider() throws {
        let controller1 = Object()
        let controller2 = Object()
        try Dirk.start {
            Module {
                Factory { controller1 }
                Factory { controller2 }
            }
        }
        
        let dirk = try Dirk.get()
        let injectedController = try dirk.get(Object.self)
        
        XCTAssertTrue(injectedController === controller2)
    }
    
    func test_multipleSingletonsProvidingTheSameType_usesTheLastProvider() throws {
        let controller1 = Object()
        let controller2 = Object()
        try Dirk.start {
            Module {
                Singleton { controller1 }
                Singleton { controller2 }
            }
        }
        
        let dirk = try Dirk.get()
        let injectedController = try dirk.get(Object.self)
        
        XCTAssertTrue(injectedController === controller2)
    }
    
    func test_aFactory_providingAClassForAProtocol_returnsTheClassWhenTheProtocolIsRequested() throws {
        let controller = Object()
        try Dirk.start {
            Module {
                Factory(Interface.self) { controller }
            }
        }
        
        let dirk = try Dirk.get()
        let injectedController = try dirk.get(Interface.self)
        
        XCTAssertTrue(injectedController === controller)
    }
    
    func test_aSingleton_providingAClassForAProtocol_returnsTheClassWhenTheProtocolIsRequested() throws {
        let controller = Object()
        try Dirk.start {
            Module {
                Singleton(Interface.self) { controller }
            }
        }
        
        let dirk = try Dirk.get()
        let injectedController = try dirk.get(Interface.self)
        
        XCTAssertTrue(injectedController === controller)
    }
    
    func test_aFactory_canBeInjectedIntoAProperty() throws {
        let object = Object()
        try Dirk.start {
            Module {
                Factory { object }
            }
        }
        
        let model = Model<Object>()
        
        XCTAssertTrue(model.value === object)
    }
    
    func test_aSingleton_canBeInjectedIntoAProperty() throws {
        let object = Object()
        try Dirk.start {
            Module {
                Singleton { object }
            }
        }
        
        let model = Model<Object>()
        
        XCTAssertTrue(model.value === object)
    }
    
    func test_injectedProperties_areInjectedLazily() throws {
        // The model is instantiated before Dirk is started. As such, if the property is not lazily
        // injected (upon use), there will be a crash.
        let model = Model<Object>()
        let object = Object()
        try Dirk.start {
            Module {
                Singleton { object }
            }
        }
        
        XCTAssertTrue(model.value === object)
    }
    
    
    // MARK: - Static Members/Types

    static var allTests = [
        ("test_factoryProvidesANewInstanceEachTimeCalled", test_factoryProvidesANewInstanceEachTimeCalled),
        ("test_singletonProvidesTheSameInstanceEachTimeCalled", test_singletonProvidesTheSameInstanceEachTimeCalled),
        ("test_multipleFactoriesProvidingTheSameType_usesTheLastProvider", test_multipleFactoriesProvidingTheSameType_usesTheLastProvider),
        ("test_multipleSingletonsProvidingTheSameType_usesTheLastProvider", test_multipleSingletonsProvidingTheSameType_usesTheLastProvider),
        ("test_aFactory_providingAClassForAProtocol_returnsTheClassWhenTheProtocolIsRequested", test_aFactory_providingAClassForAProtocol_returnsTheClassWhenTheProtocolIsRequested),
        ("test_aSingleton_providingAClassForAProtocol_returnsTheClassWhenTheProtocolIsRequested", test_aSingleton_providingAClassForAProtocol_returnsTheClassWhenTheProtocolIsRequested),
        ("test_aFactory_canBeInjectedIntoAProperty", test_aFactory_canBeInjectedIntoAProperty),
        ("test_aSingleton_canBeInjectedIntoAProperty", test_aSingleton_canBeInjectedIntoAProperty),
        ("test_injectedProperties_areInjectedLazily", test_injectedProperties_areInjectedLazily),
    ]
    
    private class Object: Interface {}
    
    private struct Model<T> {
        
        @Inject
        var value: T
    }
}

private protocol Interface: AnyObject {}
