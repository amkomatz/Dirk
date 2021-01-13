
extension Dirk {
    
    private static var current: Dirk?
    
    /// Returns the current instance of `Dirk`, if there is one.
    public static func get() throws -> Dirk {
        guard let current = current else {
            throw Exception.notStarted
        }
        
        return current
    }
    
    /// Starts `Dirk` with the specified modules.
    ///
    /// Starting up `Dirk` is very simple. Simply call `start { ... }` with the desired modules and
    /// providers.
    ///
    /// ```
    /// try Dirk.start {
    ///     FrameworkAModule()
    ///     FrameworkBModule()
    ///
    ///     Module {
    ///         Factory { ViewModelA() }
    ///         Singleton<RouterProtocol> { Router() }
    ///     }
    /// }
    /// ```
    ///
    /// - Important: In most cases, should only be called once over the lifetime of the application.
    /// Most likely, this should be called in `AppDelegate`, `SceneDelegate`, or the root view when
    /// using `SwiftUI`.
    ///
    /// - Parameters:
    ///   - builder: A closure containing the modules to register.
    public static func start(@ArrayBuilder<Module> _ builder: () -> [Module]) throws {
        if current != nil {
            throw Exception.alreadyStarted
        }
        
        let dirk = Dirk()
        builder().forEach { module in
            dirk.register(module)
        }
        
        current = dirk
    }
    
    /// Stops `Dirk`, clearing out all registered providers.
    ///
    /// - Important: Because this removes all providers, this is not recommended to be used in most
    /// cases during the lifecycle of an application. This is more useful for tests, where providers
    /// may change often.
    public static func stop() throws {
        if current == nil {
            throw Exception.notStarted
        }
        
        current = nil
    }
}
