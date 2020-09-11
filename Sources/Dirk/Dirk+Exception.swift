
extension Dirk {
    
    public enum Exception: Error {
        
        case notRegistered(Any.Type)
        case incorrectType(expected: Any.Type, actual: Any.Type)
        case dirkAlreadyStarted
        case dirkNotStarted
    }
}
