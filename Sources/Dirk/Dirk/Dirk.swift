
/// The dependency manager, responsible for communicating with modules and providers in order to
/// resolve dependencies.
public class Dirk {
    
    private var map: [String: Provider] = [:]
    
    private func key(for type: Any.Type) -> String {
        String(reflecting: type)
    }
    
    /// Registers the providers in a module with Dirk.
    public func register(_ module: Module) {
        module.providers.forEach { provider in
            map[key(for: provider.type)] = provider
        }
    }
    
    /// Attemps to resolve an instance of the given type, throwing an error if no related provider
    /// has been registered.
    ///
    /// - Parameters:
    ///   - type: The type of object to search for, instantiae, and return.
    ///
    /// - Throws: If the type can not be found, `Dirk.Exception.notRegistered` is thrown. If the
    /// object resolved by `Dirk` is not the correct type, `Dirk.Excepttion.incorrectType` is
    /// thrown.
    public func get<T>(_ type: T.Type = T.self) throws -> T {
        guard let provider = map[key(for: type)] else {
            throw Exception.notRegistered(type)
        }
        
        let _object = try provider.get(using: self)
        
        guard let object = _object as? T else {
            throw Exception.incorrectType(expected: type, actual: Swift.type(of: _object))
        }
        
        return object
    }
}
