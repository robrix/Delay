//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Takes an unevaluated closure \c value and returns a lazily-evaluating wrapper for it.
func delay<Delayed>(value: @auto_closure () -> Delayed) -> Delay<Delayed> {
	return Delay(value)
}

/// A lazily-evaluated value, convertible to its underlying type.
enum Delay<Delayed> {
	case Forced(Delayed)
	case Lazy(() -> Delayed)
	
	init(_ thunk: () -> Delayed) {
		self = .Lazy(thunk)
	}
	
	/// Force the delay, evaluating the thunk if unevaluated.
	mutating func force() -> Delayed {
		switch self {
		case let .Forced(x):
			return x
		case let .Lazy(thunk):
			let value = thunk()
			self = .Forced(value)
			return value
		}
	}
	
	
	/// Conversion to the underlying type.
	@conversion mutating func __conversion() -> Delayed {
		return force()
	}
}


/// Equality between Delays of Equatable. Forces the Delay.
func == <Delayed : Equatable> (inout left: Delay<Delayed>, inout right: Delay<Delayed>) -> Bool {
	return (left.force() == right.force())
}

/// Equality between Delays of Equatable and underlying type. Forces the Delay.
func == <Delayed : Equatable> (inout left: Delay<Delayed>, right: Delayed) -> Bool {
	return left.force() == right
}

func == <Delayed : Equatable> (left: Delayed, inout right: Delay<Delayed>) -> Bool {
	return left == right.force()
}


/// Hashing for Delays of Hashable. Forces the Delay.
func hashValue<Delayed : Hashable>(inout delay: Delay<Delayed>) -> Int {
	return delay.force().hashValue
}
