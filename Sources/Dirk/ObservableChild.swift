#if canImport(Combine)
import Combine

/// Wraps a manually-provided child `ObservableObject` and forwards its changes up to the
/// enclosing parent `ObservableObject`.
///
/// `ObservableChild` is the non-injected sibling of `ObservableInject`. Use it when the child
/// model isn't resolved from `Dirk` — for example, when it's constructed from inputs the parent
/// already has, or when it's passed in by a caller. Like `ObservableInject`, it subscribes the
/// parent to the child's `objectWillChange` so SwiftUI views observing the parent re-render when
/// the child mutates.
///
/// ```swift
/// final class FormField: ObservableObject {
///     @Published var text: String = ""
/// }
///
/// final class SignUpViewModel: ObservableObject {
///
///     @ObservableChild var email = FormField()
///     @ObservableChild var password = FormField()
///
///     var isValid: Bool {
///         !email.text.isEmpty && password.text.count >= 8
///     }
/// }
/// ```
///
/// - Important: The enclosing type must be an `ObservableObject` whose `objectWillChange`
/// publisher is the default `ObservableObjectPublisher`. If you provide a custom
/// `objectWillChange`, the subscript that wires up the forwarding will not be available and
/// changes will not be propagated.
@propertyWrapper
public final class ObservableChild<T> where T: ObservableObject {

    private var cancellable: AnyCancellable?
    private let value: T

    public init(wrappedValue: T) {
        self.value = wrappedValue
    }

    public static subscript<Parent>(
        _enclosingInstance parent: Parent,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Parent, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<Parent, ObservableChild<T>>
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
