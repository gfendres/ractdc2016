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
    private(set) var hiddenButton: MutableProperty<Bool> = MutableProperty<Bool>(true)

    private lazy var user: User = {
       return User()
    }()
    
    init() {
        
        username.signal.filter(isUsernameValid).observeNext { next in
            self.user.name = next
            self.usernameCorrect.value = true
        }
        usernameCorrect <~ username.signal.map(isUsernameValid)
        hiddenButton <~ username.signal.map(isUsernameValid).map{!$0}
        errorMessage <~ username.signal.map(errorMessageForUsername)
    }
    
    //MARK: Validation
    
    func isUsernameValid(username: String?) -> Bool {
        if let username = username where !username.isEmpty {
            return username.characters.count > minCharacters &&
                username.characters.count < maxCharacters
        }
        return false
    }
    
    func errorMessageForUsername(username: String?) -> String {
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
    
    func enterDidClick(object: UIButton) -> SignalProducer<String, NSError> {
        return saveUser(self.user)
    }
    
    private func saveUser(user: User) -> SignalProducer<String, NSError> {
        self.hiddenButton.value = true
        return SignalProducer { observe, disposable in

            if (user.name == "Darth Vader") {
                self.errorMessage.value = unavailableUsernameError
                self.usernameCorrect.value = false
                return
            }
            observe.sendNext(user.name!)
        }.delay(3, onScheduler: QueueScheduler.mainQueueScheduler)
    }
    
    //MARK: Errors
    
    private func error() -> NSError {
        return NSError.init(domain: "com.rac.userSaveError",
                            code: 002,
                            userInfo: nil)
    }
}
