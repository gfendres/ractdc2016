//
//  UserViewModel.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import AVFoundation
import ReactiveCocoa
import enum Result.NoError

let maxCharacters = 15
let minCharacters = 5
let maxCharactersError = "Seu nome deve ter no máx \(maxCharacters) characteres"
let minCharactersError = "Seu nome deve ter no min \(minCharacters) characteres"
let unavailableUsernameError = "Este nome não pode ser usado"

internal class UserViewModel {
    
    var username: MutableProperty<String?> = MutableProperty<String?>("")
    
    private(set) var errorMessage: MutableProperty<String> = MutableProperty<String>("")
    private(set) var usernameCorrect: MutableProperty<Bool> = MutableProperty<Bool>(false)
    private(set) var disableButton: MutableProperty<Bool> = MutableProperty<Bool>(true)

    private lazy var user: User = {
       return User()
    }()
    
    init() {
        username.signal.observeNext { next in
            print(next)
            let validText = self.isUsernameValid(next)
            self.disableButton.value = !validText
            self.usernameCorrect.value = validText
            self.user.name = next
            self.errorMessage.value = self.errorMessageForUsername(next!)
        }
    }
    
    //MARK: Validation
    
    func isUsernameValid(username: String?) -> Bool {
        if let username = username where !username.isEmpty {
            return username.characters.count > minCharacters &&
                username.characters.count < maxCharacters
        }
        return false
    }
    
    func errorMessageForUsername(username: String) -> String {
        return filterMinCharacters(username) ?
            minCharactersError :
            filterMaxCharacters(username) ?
            maxCharactersError : ""
    }
    
    func filterMaxCharacters(text: String?) -> Bool {
        return text!.characters.count > maxCharacters
    }
    
    func filterMinCharacters(text: String?) -> Bool {
        return text!.characters.count < minCharacters
    }
    
    //MARK: User Operations
    
    func saveUser() -> SignalProducer<(), NSError> {
        return self.saveUser(self.user)
    }
    
    private func saveUser(user: User) -> SignalProducer<(), NSError> {
        self.disableButton.value = true
        return SignalProducer { observe, disposable in
            if (user.name == "Darth Vader") {
                self.errorMessage.value = unavailableUsernameError
                observe.sendFailed(self.error())
                observe.sendInterrupted()
            }
            observe.sendCompleted()
            }
            .delay(3, onScheduler: QueueScheduler.mainQueueScheduler)
    }
    
    //MARK: Errors
    
    private func error() -> NSError {
        return NSError.init(domain: "com.rac.userSaveError",
                            code: 002,
                            userInfo: nil)
    }
}
