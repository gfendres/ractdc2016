//
//  BeerViewModel.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/9/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import Foundation
import ReactiveCocoa

class BeerViewModel {
    
    var quantity: MutableProperty<Int> = MutableProperty<Int>(0)
    var userName: MutableProperty<String> = MutableProperty<String>.init("")
    var drunkImage: MutableProperty<UIImage?> = MutableProperty<UIImage?>.init(UIImage(named: "beerImage1")!)
    
    init () {
        quantity.producer
            .promoteErrors(NSError)
            .skipRepeats()
//            .map(self.imageForBeer)
//            .flatten(FlattenStrategy.Concat)
//            .map { value in
//                self.imageForBeer(value).single()
//            }
            .map({ value in
                self.imageForBeer(value).on(
                    next: { image in
                        self.drunkImage.value = image
                    }, failed: { error in
                        print(error)
                    }, completed: {
                        print("Image download Completed")
                }).start()
            }).start()
    }
    
    func imageForBeer(quantity: Int) -> SignalProducer<UIImage?, NSError> {
        return SignalProducer { observe, disposable in
            guard let image: UIImage = UIImage(named: "beerImage\(quantity)") else {
                observe.sendNext(UIImage(named: "beerImage1"))
                observe.sendFailed(NSError.init(domain: "com.rac.imageError", code: 001, userInfo: nil))
                observe.sendInterrupted()
                return
            }
            observe.sendNext(image)
            observe.sendCompleted()
            }.delay(1, onScheduler: QueueScheduler.mainQueueScheduler)
    }
    
}
