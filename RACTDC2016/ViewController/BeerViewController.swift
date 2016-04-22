//
//  BeerViewController.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/9/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import UIKit
import ReactiveCocoa

class BeerViewController: UIViewController {

    @IBOutlet weak var beerQuantityLabel: UILabel!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var quantitySlider: UISlider!
    @IBOutlet weak var personDrunkImage: UIImageView!
    
    let beerViewModel: BeerViewModel = BeerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let beerQuantityProducer: SignalProducer = quantityField.rac_textSignal()
            .toSignalProducer()
            .observeOn(UIScheduler())
        
        beerViewModel.quantity <~ beerQuantityProducer
            .ignoreError()
            .map { value in
                let stringValue = value as? String
                return stringValue!.isEmpty ? 0 : Int(stringValue!)!
        }
        
        let beerQuantitySliderProducer: SignalProducer = quantitySlider
            .rac_signalForControlEvents(UIControlEvents.ValueChanged)
            .toSignalProducer()
            .observeOn(UIScheduler())
        
        beerViewModel.quantity <~ beerQuantitySliderProducer
            .ignoreError()
            .map { slider in
                if let sliderValue = slider as? UISlider {
                    return Int(sliderValue.value)
                }
                return 0
            }
        
        personDrunkImage.rac_image <~ beerViewModel.drunkImage
        
        //Another way to binding
        beerViewModel.quantity.signal.observeNext { value in
            self.quantityField.text = String(value)
        }
    }
}
