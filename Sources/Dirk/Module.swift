
public class Module {
    
    let providers: [Provider]
    
    public init(@ArrayBuilder _ builder: () -> [Provider]) {
        providers = builder()
    }
}
