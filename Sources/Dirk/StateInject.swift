#if canImport(SwiftUI)
import SwiftUI

/// Injects an `ObservableObject` into a SwiftUI `View` and subscribes the view to it.
///
/// `StateInject` is the SwiftUI counterpart to `Inject`. Resolve a view model from `Dirk` and have
/// the enclosing view re-render whenever the view model publishes a change — equivalent to
/// declaring `@ObservedObject var viewModel = ViewModel()`, but with the instance supplied by the
/// container instead of constructed in place.
///
/// ```swift
/// final class HomeViewModel: ObservableObject {
///     @Published var title: String = "Hello"
/// }
///
/// try Dirk.start {
///     Module {
///         Factory { HomeViewModel() }
///     }
/// }
///
/// struct HomeView: View {
///
///     @StateInject var viewModel: HomeViewModel
///
///     var body: some View {
///         Text(viewModel.title)
///     }
/// }
/// ```
///
/// Like `@ObservedObject`, `StateInject` does **not** own the lifetime of the value. If you need
/// SwiftUI to keep the same instance across view recreations, register the type as a `Singleton`
/// (or otherwise manage its lifetime) so the same instance is returned on each resolve. For
/// view-owned state, prefer SwiftUI's built-in `@StateObject`.
///
/// - Important: Because this is a property wrapper, `try!` is used to get the value. This means
/// that if `Dirk` isn't started or a provider cannot be found, a runtime crash will occur.
@propertyWrapper
public class StateInject<T>: DynamicProperty where T: ObservableObject {
    @StateObject public var wrappedValue: T

    public init() {
        _wrappedValue = StateObject(wrappedValue: try! inject())
    }
}
#endif
