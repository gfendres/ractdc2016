//
//  SignalProducerExtension.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/10/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

protocol AnOptional {
    associatedtype Wrapped
    func asOptional() -> Wrapped?
}

extension Optional : AnOptional {
    func asOptional() -> Wrapped? {
        return self
    }
}

extension SignalProducer {

public func ignoreError() -> SignalProducer<Value, NoError> {
        return flatMapError { error in
            print(error)
            return SignalProducer<Value, NoError>.empty
        }
    }
}

extension SignalProducer where Value : AnOptional {
    func ignoreNilValues() -> SignalProducer<Value.Wrapped,Error> {
        return self.filter { return $0 != nil }.map { $0.asOptional()! }
    }
}

public func merge<T, E>(signals: [SignalProducer<T, E>]) -> SignalProducer<T, E> {
    return SignalProducer<SignalProducer<T, E>, E>(values: signals).flatten(.Merge)
}