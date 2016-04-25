//
//  BeerViewModel.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/9/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

class BeerViewModel {
    
    var quantity: MutableProperty<Int> = MutableProperty<Int>(0)
    private(set) var userName: MutableProperty<String> = MutableProperty<String>.init("")
    private(set) var userImage: MutableProperty<UIImage?> = MutableProperty<UIImage?>.init(UIImage(named: "beerImage1")!)
    
    init () {
        quantity.producer
            .skipRepeats() // Skip the same value. Ex: 1, 1, 1, 2, 2, 2. It gets only 1, 2
            .flatMap(FlattenStrategy.Latest, transform: self.imageForBeer) // Change to Merge in order to get multiple images.
            .startWithNext { image in
                print("Image Received")
                self.userImage.value = image
            }
    }
    
    func imageForBeer(quantity: Int) -> SignalProducer<UIImage?, NoError> {
        return SignalProducer { observe, disposable in
            print("Image for Quantity: \(quantity)")
            guard let image: UIImage = UIImage(named: "beerImage\(quantity)") else {
                return
            }
            observe.sendNext(image)
//            observe.sendCompleted()
            }.delay(1, onScheduler: QueueScheduler.mainQueueScheduler)
    }
    
}
