
public class Singleton<T>: Provider {
    
    public let type: Any.Type
    private let builder: () throws -> T
    private var calledBuilder: Bool = false
    private var value: T?
    
    public init(_ type: T.Type = T.self, _ builder: @escaping () throws -> T) {
        self.type = type
        self.builder = builder
    }
    
    public func get() throws -> Any {
        if calledBuilder {
            return value!
        } else {
            value = try builder()
            calledBuilder = true
            return value!
        }
    }
}
