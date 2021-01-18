# Dirk

A lightweight, typesafe dependency injection framework for Swift.

# Introduction

Dirk is a lightweight and typesafe dependency injection framework for Swift. Dirk focuses on removing direct 
initialization of dependencies, moving them to a higher level so objects no longer need to create their own 
dependencies. This not only allows for greater flexibility, but also increases the testability, readability, and 
reusability of code.

# How to Use Dirk

## Installation

Dirk only supports Swift Package Manager for installation. Simply add the following dependency to your
`Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/amkomatz/Dirk", from: "1.0.0")
]
```

## Basic Use

Using Dirk is extremely simple, but also allows for great flexibility.

Dirk must be started once through the `Dirk.start(_:)` method. In this method, all modules and providers the
app requires are included.

```swift
try! Dirk.start {
    Module {
        Factory { ViewModelA() }
        Singleton { Router() }
    }
}
```

Concrete implementations of protocols can also be provided by including a generic parameter:

```swift
try! Dirk.start {
    Module {
        Factory<ViewModelAProtocol> { ViewModelA() }
        Singleton<RouterProtocol> { Router() }
    }
}
```

There are several methods to retrieve instances provided by Dirk:

```swift
// 1. To inject a local variable (functions, computed properties, etc.)
let viewModel: ViewModelA = try inject()
let viewModel = try inject(ViewModelA.self)

// 2. To inject a property on a class or struct
@Inject var viewModel: ViewModelA
```

Note that method (1) allows for error handling (`try`), if for some reason the requested instance cannot be 
resolved. However, method (2) cannot allow for error handling, since property wrappers and properties on 
classes and structs cannot handle errors. This means that if an instance cannot be resolved, a runtime crash will
occur. But as long as a provider is registered for the specific type, no runtime crash will occur. In most cases,
method (2) is recommended.

## Providers

Providers come in several flavors, but they all have the same base functionality: to provide instances of a 
specific type. Different flavors of providers have slight differences in how objects are created, stored, etc. 

### Factories

Factories provide a new instance of a specified type every time one is requested. That is, the factory doesn't
persist, store, or hang on to the instances that it creates. As such, they are the preferred provider in most
scenarios, since they cannot leak an object.

The initializer for `Factory` takes a closure that returns an instance of `T`. This block will be executed each time
an instance of `T` is requested, and each instance will be unique.

Using `Factory` is very simple, just add one to a module:

```swift
try! Dirk.start {
    Module {
        Factory { ViewModelA() }
    }
}
```

As with all providers, a protocol can be specified at `T`:

```swift
try! Dirk.start {
    Module {
        Factory<ViewModelAProtocol> { ViewModelA() }
    }
}
```

### Singletons

Singletons provide the same instance of a specified type every time one is requests. That is, the factory stores
the first instance it creates. Use this with extreme care, and only in specific situations. In the vast majority of
cases, singletons are not the appropriate provider. They are only recommended in cases where only a single
instance of a type should exist for the entire application, such as a global router, app delegate, configuration, 
etc.

The initializer for `Singleton` also takes a closure that returns an instance of `T`. This block will be executed only
once, the first time `T` is requested. Only one instance of `T` will ever be generated and returned.

Using `Singleton` is also very simple, just add one to a module:

```swift
try! Dirk.start {
    Module {
        Singleton { Router() }
    }
}
```

As with all providers, a protocol can be specified at `T`:

```swift
try! Dirk.start {
    Module {
        Singleton<RouterProtocol> { Router() }
    }
}
```

### Other Providers

Currently, no other providers have been implemented. However, recommendations are very welcome!

## Modularization

A module is a lightweight grouping of providers. 

Modules are a powerful way to organize dependencies, especially when dealing with frameworks. For example,
a module can be created for web services, view models, etc. When creating specific modules, subclassing is
recommended:

```swift
// Create the module as a subclass of `Module`
final class ViewModelModule: Module {
    
    init() {
        super.init {
            Factory { ViewModelA() }
            Factory { ViewModelB() }
            // ...
        }
    }
}

// Then register it by initializing the module
try! Dirk.start {
    ViewModelModule()
    WebServiceModule()
    // ...
}
```

If your app uses frameworks, whether internal or third party, the same approach can be used:

```swift
final class FrameworkAModule: Module {
    
    init() {
        super.init {
            Factory { ObjectA() }
            Factory { ObjectB() }
            // ...
        }
    }
}

try! Dirk.start {
    FrameworkAModule()
    FrameworkBModule()
    // ...
}
```

## Testing

An enourmous benefit to using dependency injection is that testing becomes much easier. Because objects
don't create their own dependencies, mocking is extremely simple. Just create a mock, and provide it to Dirk!

```swift
// Class definition
final class ObjectA {

    @Inject private var dependency: DependencyAProtocol
    
    // ...
}

// Create a mock of the dependency
struct DependencyAMock: DependencyAProtocol {
    
    // ...
}

// In the tests for `ObjectA`, just inject the mock!
func testSomeBehaviorOfObjectA() {
    let mock = DependencyAMock()
    
    try! Dirk.start {
        Module {
            Factory<DependencyAProtocol> { mock }
        }
    }
    
    let object = ObjectA()
    
    // Execute the test!
}
```
