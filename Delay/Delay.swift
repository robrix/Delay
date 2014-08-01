//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Takes an unevaluated closure \c value and returns a lazily-evaluating wrapper for it.
public func delay<Delayed>(value: @auto_closure () -> Delayed) -> Delay<Delayed> {
	return Delay(value)
}

/// Takes an unevaluated closure \c value and returns a lazily-evaluating wrapper for it.
public func delay<Delayed>(value: () -> Delayed) -> Delay<Delayed> {
	return Delay(value)
}

/// A lazily-evaluated value, convertible to its underlying type.
public final class Delay<Delayed: Reflectable> {
	/// The underlying value. Lazily evaluates and produces the receiving type.
	public lazy var value: Delayed = {
		let value = self._thunk!()
		self._thunk = nil
		return value
	}()
	
	public init(_ thunk: () -> Delayed) {
		_thunk = thunk
	}
	
	/// Conversion to the underlying type.
	public func __conversion() -> Delayed {
		return value
	}
	
	var _thunk: (() -> Delayed)?
}


/// Equality between Delays of Equatable. Forces the Delay.
func == <Delayed : Equatable> (left: Delay<Delayed>, right: Delay<Delayed>) -> Bool {
	return ((left as Delayed) == (right as Delayed))
}

/// Equality between Delays of Equatable and underlying type. Forces the Delay.
func == <Delayed : Equatable> (left: Delay<Delayed>, right: Delayed) -> Bool {
	return (left as Delayed) == right
}

func == <Delayed : Equatable> (left: Delayed, right: Delay<Delayed>) -> Bool {
	return left == (right as Delayed)
}


/// Hashing for Delays of Hashable. Forces the Delay.
public func hashValue<Delayed : Hashable>(delay: Delay<Delayed>) -> Int {
	return (delay as Delayed).hashValue
}
