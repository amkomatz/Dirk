
/// An object that provides instances of a specific type to `Dirk`.
public protocol Provider {
    
    /// The type that the factory will instantiate.
    var type: Any.Type { get }
    
    /// Instantiates and returns an instance of `type`.
    func get(using dirk: Dirk) throws -> Any
}
