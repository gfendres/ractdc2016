//: Playground - noun: a place where people can play

import UIKit
import ReactiveCocoa

var str = "Hello, playground"



let (signal, observer) = Signal<Int, NSError>.pipe()

let (signalP, observerA) = SignalProducer<String, NSError>.buffer(3)
signalP.startWithNext { a in print(a)}
observerA.sendNext("Test")
observerA.sendNext("a")
observerA.sendNext("b")

signal
    .map { number in number + 2 }
    .filter { number in number % 2 == 0 }
    .observeNext { next in print(next) }
signal.observeCompleted { 
    print("Completed")
}

observer.sendNext(1)     // Not printed
observer.sendNext(2)     // Prints 2
observer.sendNext(3)     // Not printed
observer.sendNext(4)     // prints 4
observer.sendNext(10)
observer.sendCompleted()

var obs2: Observer<String, NSError>!
let signal2 = Signal<String, NSError>.init { (observer) -> Disposable? in
    obs2 = observer
    return nil
}.observeNext { (text) in
    print(text)
}

let text = MutableProperty<String>("Goo")
text.producer
    .map { t in t + "aa"}
    .observeOn(UIScheduler())
    .startWithNext { next in print(next) }

text.signal
    .map { t in t + "bb"}
    .observeOn(QueueScheduler.mainQueueScheduler)
    .observeNext { next in print(next) }

text.signal.map {a in a + "dd"}.observe { event in
    switch event {
    case let .Next(value):
        print(value)
        break
    default:
        break
    }
}//.observeNext{ n in print(n) }

obs2.sendNext("casa")

text.modify { t in t + "CC" }

print(text.value)

let myObserver: Observer<Int,NSError> = Observer<Int,NSError> { event in
    switch event {
    case let .Next(next):
        print(next)
    case .Completed:
        print("Complted")
    default:
        print("Default")
    }
}

struct Beer {
    var type: String
    var alcohoolPercent: Float
    init(beerType: String, percent: Float) {
        type = beerType
        alcohoolPercent = percent
    }
}

let beers = [Beer(beerType: "Weiss", percent: 5.8),
             Beer(beerType: "Pilsen", percent: 4.5),
             Beer(beerType: "RedAle", percent: 7.2),
             Beer(beerType: "Dunkel", percent: 8.5)]

var strongBeers = [Beer]();
//Mark: Imperative
for beer in beers {
    if beer.alcohoolPercent > 6 {
        strongBeers.append(beer)
    }
}
print(strongBeers)

var lastBeer: Beer?
for beer in strongBeers {
    if beer.alcohoolPercent > lastBeer?.alcohoolPercent {
        lastBeer = beer
    }
}
print(lastBeer)

//Mark: Declarative
strongBeers = beers.filter{ $0.alcohoolPercent > 6 }
beers.sort{ (beer, beer2) in beer.alcohoolPercent > beer2.alcohoolPercent }

print(strongBeers)
