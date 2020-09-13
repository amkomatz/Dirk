
public protocol Provider {
    
    var type: Any.Type { get }
    
    func get(using dirk: Dirk) throws -> Any
}
