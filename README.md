# Delay

This is a Swift microframework which implements a lazily-evaluated memoizing wrapper type.

It’s a bit like a promise.

## Why not just use a closure?

- Closures do not automatically memoize; Delay will evaluate zero or one times, whereas closures will evaluate every time they are called.
- Closures are currently subject to `non-fixed multi-payload enum layout` errors; since Delay is a class, it does not cause these problems for `enum` layout.

## Use

```swift
func expensiveComputation() -> Int
let delayedResult = delay(expensiveComputation)
let actualResult = delay.value // explicitly force it
let otherActualResult: Int = delay // use the implicit __conversion
```

See [`Delay.swift`][Delay.swift] for more details.

## Integration

1. Add this repo as a submodule in e.g. `External/Delay`:
  
        git submodule add https://github.com/robrix/Delay.git External/Delay
2. Drag `Delay.xcodeproj` into your `.xcworkspace`/`.xcodeproj`.
3. Add `Delay.framework` to your target’s `Link Binary With Libraries` build phase.
4. You may also want to add a `Copy Files` phase which copies `Delay.framework` (and any other framework dependencies you need) into your bundle’s `Frameworks` directory. If your target is a framework, you may instead want the client app to include `Delay.framework`.

[Delay.swift]: https://github.com/robrix/Delay/blob/master/Delay/Delay.swift
