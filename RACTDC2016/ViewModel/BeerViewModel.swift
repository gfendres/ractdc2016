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
        userImage <~ quantity.producer
            .skipRepeats() // Skip the same value. Ex: 1, 1, 1, 2, 2, 2. It gets only 1, 2
            .flatMap(FlattenStrategy.Latest, transform: imageForBeer) // Change to Merge in order to get multiple images.

    }
    
    func imageForBeer(quantity: Int) -> SignalProducer<UIImage?, NoError> {
        return SignalProducer { observe, disposable in
            print("Image for Quantity: \(quantity)")
            guard let image: UIImage = UIImage(named: "beerImage\(quantity)") else {
                print("Failed to get image for quantity \(quantity)")
                return
            }
            observe.sendNext(image)
            }.delay(1, onScheduler: QueueScheduler.mainQueueScheduler)
    }
    
}
