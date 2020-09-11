
public class Factory<T>: Provider {
    
    public let type: Any.Type
    private let builder: () throws -> T
    
    public init(_ type: T.Type = T.self, _ builder: @escaping () throws -> T) {
        self.type = type
        self.builder = builder
    }
    
    public func get() throws -> Any {
        try builder()
    }
}
