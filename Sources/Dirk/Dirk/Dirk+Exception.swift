
extension Dirk {
    
    public enum Exception: Error {
        
        /// A provider for the requested type has not been registered.
        ///
        /// If this exception occurs, make sure a provider for the type is being added to a module
        /// registered with `Dirk`.
        case notRegistered(Any.Type)
        
        /// The registered provider returned the wrong type.
        ///
        /// - Parameters:
        ///   - expected: The type that was expected to be resolved.
        ///   - actual: The type that was actually resolved.
        case incorrectType(expected: Any.Type, actual: Any.Type)
        
        /// Dirk has already been started.
        ///
        /// If this exception occurs, it means `Dirk.start(_:)` is being called more than once
        /// without first calling `Dirk.stop()`.
        case alreadyStarted
        
        /// Dirk has not yet been started.
        ///
        /// If this exception occurs, make sure `Dirk.start(_:)` is being called, and `Dirk.stop()`
        /// is not being called.
        case notStarted
    }
}
