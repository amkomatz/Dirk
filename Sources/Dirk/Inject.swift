
@propertyWrapper
public class Inject<T> {
    
    public lazy var wrappedValue: T = try! Dirk.get().get()
    
    public init() {}
}
