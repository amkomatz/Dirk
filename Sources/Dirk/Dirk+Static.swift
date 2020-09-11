
extension Dirk {
    
    private static var current: Dirk?
    
    public static func get() throws -> Dirk {
        guard let current = current else {
            throw Exception.dirkNotStarted
        }
        
        return current
    }
    
    public static func start(@ArrayBuilder _ builder: () -> [Module]) throws {
        if current != nil {
            throw Exception.dirkAlreadyStarted
        }
        
        let dirk = Dirk()
        builder().forEach { module in
            dirk.add(module)
        }
        
        current = dirk
    }
    
    public static func stop() throws {
        if current == nil {
            throw Exception.dirkNotStarted
        }
        
        current = nil
    }
}
