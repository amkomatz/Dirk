
/// Injects an instance of the requested type upon being accessed.
///
/// Note that if an instance of the type cannot be resolved, a crash will occur (see below). Also,
/// the type will not be injected until it is accessed. That is, the wrapped value is `lazy`.
///
/// - Important: Because this is a property wrapper, `try!` is used to get the value. This means
/// that if `Dirk` isn't started or a provider cannot be found, a runtime crash will occur.
@propertyWrapper
public class Inject<T> {
    
    public lazy var wrappedValue: T = try! inject()
    
    public init() {}
}

/// Injects an instance of the requesed type.
public func inject<T>(_ type: T.Type = T.self) throws -> T {
    try Dirk.get().get()
}
