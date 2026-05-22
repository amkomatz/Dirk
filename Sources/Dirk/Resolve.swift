
/// Resolves a fresh instance of the requested type every time the property is accessed.
///
/// Unlike `Inject`, which resolves the dependency lazily once and then caches it, `Resolve` calls
/// the registered provider on every access. This makes it the right choice when paired with a
/// `Factory` provider whose work should run again per use — for example, when each access should
/// reflect the current state of the container, or when the dependency should not be retained by
/// the enclosing instance between accesses.
///
/// ```swift
/// try Dirk.start {
///     Module {
///         Factory { RequestBuilder() }
///     }
/// }
///
/// struct APIClient {
///
///     // A new `RequestBuilder` is produced on every read.
///     @Resolve var builder: RequestBuilder
///
///     func send() {
///         let request = builder.build(...)
///         // ...
///     }
/// }
/// ```
///
/// - Important: Because this is a property wrapper, `try!` is used to get the value. This means
/// that if `Dirk` isn't started or a provider cannot be found, a runtime crash will occur.
@propertyWrapper
public class Resolve<T> {

    public var wrappedValue: T { try! inject() }

    public init() {}
}
