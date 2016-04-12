//
//  UserViewModel.swift
//  RACTDC2016
//
//  Created by Guilherme Endres on 4/3/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

import AVFoundation
import ReactiveCocoa

let maxCharacters = 15
let minCharacters = 5

class UserViewModel {
    
    var searchText: MutableProperty<String?> = MutableProperty<String?>("")
    var errorMessage: MutableProperty<String> = MutableProperty<String>("")
    var showError: MutableProperty<Bool> = MutableProperty<Bool>(false)
    var enableButton: MutableProperty<Bool> = MutableProperty<Bool>(false)

    private var user: User?
    
    init() {
        searchText.signal
            .observeNext { next in
                print(next)
                let validText = next?.characters.count < maxCharacters
                             && next?.characters.count > minCharacters
                self.enableButton.value = validText
                self.showError.value = validText
        }
        searchText.signal
            .filter { text in text?.characters.count > maxCharacters }
            .observeNext { next in
                self.errorMessage.value = "Seu nome deve ter no máx \(maxCharacters) characteres"
        }
        searchText.signal
            .filter { text in text?.characters.count < minCharacters }
            .observeNext { next in
                self.errorMessage.value = "Seu nome deve ter no min \(minCharacters) characteres"
        }
        
    }
}
