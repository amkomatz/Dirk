
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
