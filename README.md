# YourScore

A simple single screen app that displays a credit score. 

## What does it do?

On opening, the app fetches a mock credit script from an external API end-point. While the network operation is happening an animated ring is shown to indicate that we're loading the data. Once the network operation has been completed successfully and processing has finished the animation proceeds one further time and then the ring will animate by drawing a partial stroke based on the received credit score represented as a percentage.

In the case that the network operation failed the animating ring will turn red and then a final animation will happen where the ring will grow and shrink to indicate something has gone wrong to grab the user attention. A brief message and retry button will be shown to give the user the option of retrying the request.

## Running the app

You need at least Xcode 13 to build and run the app. This app is designed to target devices running iOS 15 and later.

For best experience please run the app on a physical device. When running on the simulator there is a glitch when repeating the animation which isn't exhibited when running on physical devices.

## Points of interest

- Uses MVVM-C architecture
- Uses CoreAnimaton to animate score indicator
- Uses Combine for ViewModel bindings and Networking logic
- Supports iPhone and iPad
- Optimised for Voice Over
- Supports Dynamic Text Size
- Includes comprehensive Unit and UI Snapshot tests
- Uses "static configuration" approach to creating stubs, mocks and spies

## Implementation goals

- Create a production quality credit score viewer
- Focus on code quality (i.e. simple, clean, reusable, testable)
- Simple yet engaging design
- Accessible esp. with Apple's VoiceOver and Dynamic Text sizing
- Decent level of test coverage including UI tests
- Scaling UI that works on a range of devices ranging iPod Touch, to iPad Pro 11"
- Keep the scope of the project small and defined so that the basics are done well

## Architecture

This app uses Model View ViewModel - Coordinator architectural pattern. While the architecture is not a silver bullet it's a step improvement on MVC and helps to avoid massive View Controllers. MVVM works well here and ensures that the business rules are easily testable independently of the view layer.

## Libraries used

### Combine

Apple reactive framework used to bind the view layer and view model layer including View Model to View Model bindings. The `Service.swift` class uses Combine to perform the network operation and handle the response parsing.

### CoreAnimation

CoreAnimation is used to draw and animate the circle and ring `CAShapeLayer` instances. This makes animating things like the score ring stroke trivial.

### Point-free snapshot testing

This is the only third-party library used. It is used to simplify UI testing using snapshots. 

## Static configurations

A "Static Configurations" is a self-coined term that covers types that can be initialised by one or more static methods.

The pattern was first shown by Point-free in their video series on Dependencies. The technique presents an alternative to using protocols for purposes of mocking and stubbing. 

While Protocols are commonly used for this purpose they are not always ideal due to various limitations with Swift's implementation of Protocols, most common limitations are around using Protocols as existential types. 

Concrete types are nearly always simpler to work with and the "Static Configuration" approach allows the creation of live and mock instances by populating the implementation of the shared concrete type which acts as an interface.

As an example, the interface is defined not as a protocol but as a class which is the real concrete type:

```swift
final class Service {

    var fetch: (_ completion: @escaping Result<Model, ServiceError>) -> Void) -> Void
}
```

The `Service` class has a single property called `fetch` that accepts a closure with an argument of a callback closure. This will act as a proxy for an instance method.

We can then create a static configuration instance of the class by populating the closures defined in the interface as shown in this simplified example:

```swift
extension Service {
    let live = Self(
        fetch: { completion in

            let url = ...

            URLSession.main.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: Model.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { error in
                    completion(.failure(error))
                }, receiveValue: { quote in
                    completion(.success(model))
                })
        }
    )
}
```

An advantage is that live implementation is encapsulated within the `live` instance. We can now create a stub like:

```swift
static let stub = Service(
    fetch: { completion in
        completion(.success(
            Model(
                score: 578,
                minScore: 0,
                maxScore: 700
            )
        ))
    }
)
```

The stub doesn't need to conform to any protocol or any requirements of the live implementation. It does not have any networking logic or any networking dependencies.

We can create as many configurations as we want, a failing configuration might look like:

```swift
static let failing = Service(
    fetch: { completion in
        completion(.failure(ServiceError.networkError))
    }
)
```

Using these static configurations is simple, given a ViewModel like:

```swift
class MyViewModel {

    let service: Service

    init(service: Service) {
        self.service = service
    }
}
```

We can then instantiate and inject the static configurations like so:

```swift
let viewModel = MyViewModel(service: .live)
let viewModel = MyViewModel(service: .stub)
let viewModel = MyViewModel(service: .failing)

viewModel.fetch { result in
	
	// handle ressult
}
```

## Testing

The application has a comprehensive test suite of unit and UI snapshot tests. This ensures future regressions are avoided and changes can be made with a high degree of confidence.

The snapshot tests need to be executed on the same OS and environment to avoid false negatives. The snapshot tests were taken on the following configuration:

- MacBook Pro M1 Pro
- macOS 12.2
- Xcode 13.2.1
- iPhone 13 simulator

In production, the snapshots would be generated on the CI build machine to ensure tests are reliable.

See https://github.com/pointfreeco/swift-snapshot-testing for more information the limitations of snapshot testing.
