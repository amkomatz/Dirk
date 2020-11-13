
public class Dirk {
    
    private var map: [String: Provider] = [:]
    
    public func add(_ module: Module) {
        module.providers.forEach { provider in
            map[String(reflecting: provider.type)] = provider
        }
    }
    
    public func get<T>(_ type: T.Type = T.self) throws -> T {
        guard let provider = map[String(reflecting: type)] else {
            throw Exception.notRegistered(type)
        }
        
        let _object = try provider.get(using: self)
        
        guard let object = _object as? T else {
            throw Exception.incorrectType(expected: type, actual: Swift.type(of: _object))
        }
        
        return object
    }
}
