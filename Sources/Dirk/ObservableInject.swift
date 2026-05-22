#if canImport(Combine)
import Combine

/// Injects a child `ObservableObject` into a parent `ObservableObject` and forwards its changes
/// up to the parent.
///
/// SwiftUI's `@ObservedObject` only forwards changes to a `View`. When the enclosing type is
/// another `ObservableObject` — typically a view model that composes smaller models — there is no
/// built-in way to have the parent's `objectWillChange` fire when one of its children publishes.
/// `ObservableInject` bridges that gap: it resolves the child from `Dirk` and subscribes the
/// parent to the child's `objectWillChange`, so SwiftUI views observing the parent re-render when
/// the child mutates.
///
/// ```swift
/// final class SessionStore: ObservableObject {
///     @Published var user: User?
/// }
///
/// final class HomeViewModel: ObservableObject {
///
///     // Parent re-publishes whenever `session.user` changes.
///     @ObservableInject var session: SessionStore
///
///     var greeting: String { "Hello, \(session.user?.name ?? "guest")" }
/// }
/// ```
///
/// - Important: The enclosing type must be an `ObservableObject` whose `objectWillChange`
/// publisher is the default `ObservableObjectPublisher`. If you provide a custom
/// `objectWillChange`, the subscript that wires up the forwarding will not be available and
/// changes will not be propagated.
///
/// - Important: Because this is a property wrapper, `try!` is used to get the value. This means
/// that if `Dirk` isn't started or a provider cannot be found, a runtime crash will occur.
@propertyWrapper
public final class ObservableInject<T> where T: ObservableObject {

    private var cancellable: AnyCancellable?
    private let value: T = try! inject()

    public init() {}

    public static subscript<Parent>(
        _enclosingInstance parent: Parent,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Parent, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<Parent, ObservableInject<T>>
    ) -> T where Parent: ObservableObject, Parent.ObjectWillChangePublisher == ObservableObjectPublisher {
        get {
            let wrapper = parent[keyPath: storageKeyPath]

            if wrapper.cancellable == nil {
                wrapper.cancellable = wrapper.value.objectWillChange
                    .sink { [weak parent] _ in
                        parent?.objectWillChange.send()
                    }
            }

            return wrapper.value
        }
        set {
            fatalError()
        }
    }

    public var wrappedValue: T {
        get { value }
        set { fatalError() }
    }
}
#endif
