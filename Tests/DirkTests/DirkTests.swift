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
    
    func test_aProviderCanUseOtherProviders() throws {
        let object = Object()
        let model = Model<Object>()
        try Dirk.start {
            Module {
                Singleton { object }
                Factory { model }
                Factory { try Model2<Object>(value: $0.get()) }
            }
        }
        
        let model2 = try Dirk.get().get(Model2<Object>.self)
        
        XCTAssertTrue(model2.value === object)
    }
    
    func test_twoNestedProvidersWithTheSameClassName_doNotConflict() throws {
        struct ViewA {
            class ViewModel {}
        }
        struct ViewB {
            class ViewModel {}
        }
        try Dirk.start {
            Module {
                Factory { ViewA.ViewModel() }
                Factory { ViewB.ViewModel() }
            }
        }
        
        _ = try Dirk.get().get(ViewA.ViewModel.self)
        _ = try Dirk.get().get(ViewB.ViewModel.self)
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
        ("test_aProviderCanUseOtherProviders", test_aProviderCanUseOtherProviders),
    ]
    
    private class Object: Interface {
        
        let property: Int = 100
    }
    
    private struct Model<T> {
        
        @Inject
        var value: T
    }
    
    private struct Model2<T> {
        
        let value: T
    }
}

private protocol Interface: AnyObject {}
