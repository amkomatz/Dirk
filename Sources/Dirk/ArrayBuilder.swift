
/// Builds an array of elements.
///
/// - Note: For Swift versions less than 5.3, passing a single element in an `@ArrayBuilder`
/// function or closure will result in an error. This is a bug, due to the closure being treated as
/// `() -> T`, instead of `() -> [T]`.
@_functionBuilder
public struct ArrayBuilder {
    
    public static func buildBlock<T>(_ components: T...) -> [T] {
        components
    }
}
