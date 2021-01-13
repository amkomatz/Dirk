
/// A provider that instantiates a new instance of `T` every time one is requested.
///
/// As stated above, each time this provider is invoked, a new instance of the type will be created.
/// For example:
///
/// ```swift
/// try Dirk.start {
///     Module {
///         Factory { ViewModelA() }
///     }
/// }
///
/// struct ViewA: View {
///
///     @Inject var viewModel: ViewModelA
/// }
///
/// ViewA().viewModel // This is one instance
/// ViewA().viewModel // and this is another instance.
/// ```
public class Factory<T>: Provider {
    
    public let type: Any.Type
    
    private let builder: (Dirk) throws -> T
    
    public init(_ type: T.Type = T.self, _ builder: @escaping () throws -> T) {
        self.type = type
        self.builder = { _ in try builder() }
    }
    
    public init(_ type: T.Type = T.self, _ builder: @escaping (Dirk) throws -> T) {
        self.type = type
        self.builder = builder
    }
    
    public func get(using dirk: Dirk) throws -> Any {
        try builder(dirk)
    }
}
