
public protocol Provider {
    
    var type: Any.Type { get }
    
    func get() throws -> Any
}
