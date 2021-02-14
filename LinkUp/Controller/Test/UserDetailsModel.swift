//
//  TestModel.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//

import Foundation
import Firebase

class TestModel {
    
    var isFormValid = Bindable<Bool>()
    
    var name: String? { didSet { checkFormValidity() } }
    var committment: String?
    var committmentRow: Int?
    var college: String?
    var bio: String?
    var idea: String?
    var ideaRow: Int?
    var hackathon: String?
    var skills: [String]?
    
    func checkFormValidity() {
        let isValid = name?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func fillValues(user: User) {
        name = user.name
        committment = user.committment
        committmentRow = committmentIndex(value: user.committment!)
        college = user.college
        bio = user.bio
        idea = user.idea
        ideaRow = ideaIndex(value: user.idea!)
        hackathon = user.hackathon
    }
    
    func committmentIndex(value: String) -> Int {
        if (value == "N/A") { return 0 }
        else if value == "Low" { return 1 }
        else if value == "Medium" { return 2 }
        else  { return 3 }
    }
    
    func ideaIndex(value: String) -> Int {
        if (value == "N/A") { return 0 }
        else if value == "Have an idea" { return 1 }
        else  { return 2 }
    }
}



