//
//  ViewController.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/2/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    let userViewModel: UserViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textSignal: RACSignal = nameTextField.rac_textSignal()
        let textSignalProducer: SignalProducer = textSignal.toSignalProducer().observeOn(UIScheduler())

        userViewModel.searchText <~ textSignalProducer
            .ignoreError()
            .map { text in text as? String }
            .throttle(0.5, onScheduler: QueueScheduler.mainQueueScheduler)
        
        errorLabel.rac_text <~ userViewModel.errorMessage
        errorLabel.rac_hidden <~ userViewModel.showError
        enterButton.rac_enabled <~ userViewModel.enableButton

        let buttonSignal: RACSignal = enterButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
        let buttonSignalProducer: SignalProducer = buttonSignal.toSignalProducer().observeOn(UIScheduler())
        
        buttonSignalProducer
            .throttle(1, onScheduler: QueueScheduler.mainQueueScheduler)
            .take(2)
            .on (
                next: { object in
                    guard let button = object as? UIButton else {
                        return
                    }
                    button.tintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                    button.setTitle("Are you ready", forState: UIControlState.Normal)
                },
                completed: {
                    self.performSegueWithIdentifier("beerControllerSegue", sender: self)
            })
            .start()
        
    }

}

