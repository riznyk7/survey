//
//  Functions.swift
//  Survey
//
//  Created by Piter Miller on 1/24/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation

public func cast<V, R>(_ value: V) -> R? {
    return value as? R
}

public func identity<Value>(_ value: Value) -> Value {
    return value
}

//public func ignoreInput<Value, Result>(_ action: @escaping () -> Result) -> (Value) -> Result {
//    return { _ in action() }
//}
//
//public func returnValue<Value>(_ value: Value) -> () -> Value {
//    return { value }
//}
//
//public func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
//    return { a in
//        { f(a, $0) }
//    }
//}
//
//public func uncurry<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
//    return { f($0)($1) }
//}
//
//public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
//    return { b in
//        { f($0)(b) }
//    }
//}
//
//public func flip<A, B, C>(_ f: @escaping (A, B) -> C) -> (B, A) -> C {
//    return { f($1, $0) }
//}
//
//public func compose<A>(_ a: A, _ b: A, action: @escaping (A, A) -> A) -> A {
//    return action(a, b)
//}
