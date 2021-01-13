
/// A container for providers, typically useful for grouping similar providers together.
///
/// Modules can be created ad-hoc or inherited from. For example, the module for an app might be
/// created when starting `Dirk`. However, a framework may subclass `Module`, providing a module
/// that can easily be added to `Dirk`. For example:
///
/// ```swift
/// // In FrameworkA
/// public class FrameworkAModule: Module {
///
///     init() {
///         super.init {
///             Factory { Dependency1() }
///             Factory { Dependency2() }
///             Singleton { Dependency3() }
///         }
///     }
/// }
///
/// // In the main application
/// try Dirk.start {
///     // Add FrameworkA dependencies
///     FrameworkAModule()
///
///     // Add the main app dependencies
///     Module {
///         Factory { DependencyA() }
///         Factory { DependencyB() }
///         Singleton { DependencyC() }
///     }
/// }
/// ```
open class Module {
    
    let providers: [Provider]
    
    public init(@ArrayBuilder<Provider> _ builder: () -> [Provider]) {
        providers = builder()
    }
}
