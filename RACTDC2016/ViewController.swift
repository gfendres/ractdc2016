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

        userViewModel.username <~ textSignalProducer
            .ignoreError()
            .map { text in text as? String }
            .throttle(0.5, onScheduler: QueueScheduler.mainQueueScheduler)
        
        errorLabel.rac_text <~ userViewModel.errorMessage
        errorLabel.rac_hidden <~ userViewModel.usernameCorrect
        enterButton.rac_hidden <~ userViewModel.disableButton

        let buttonSignal: RACSignal = enterButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
        let buttonSignalProducer: SignalProducer = buttonSignal.toSignalProducer().observeOn(UIScheduler())
        
        buttonSignalProducer.startWithNext { object in
            self.userViewModel.saveUser().on(
                completed: {
                    self.performSegueWithIdentifier("beerControllerSegue", sender: self)
                }, failed: { error in
                    print(error)
                }).start()
        }
    }

}

