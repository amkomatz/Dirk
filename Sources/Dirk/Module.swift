
open class Module {
    
    let providers: [Provider]
    
    public init(@ArrayBuilder<Provider> _ builder: () -> [Provider]) {
        providers = builder()
    }
}
