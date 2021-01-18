# Dirk

A lightweight, typesafe dependency injection framework for Swift.

# Introduction

Dirk is a lightweight and typesafe dependency injection framework for Swift. Dirk focuses on removing direct 
initialization of dependencies, moving them to a higher level so objects no longer need to create their own 
dependencies. This not only allows for greater flexibility, but also increases the testability, readability, and reusability of 
code. 

# How to Use Dirk

## Basic Use

Using Dirk is extremely simple, but also allows for great flexibility.

Dirk must be started once through the `Dirk.start(_:)` method. In this method, all modules and providers the app
requires are included.

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

## Modularization

## Providers

### Factories

### Singletons

### Custom Providers

## Testing

# Scenarios

## Dependency Carrying
