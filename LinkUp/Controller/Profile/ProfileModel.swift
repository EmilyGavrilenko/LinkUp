//
//  ProfileModel.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//

import Foundation
import Firebase
import JGProgressHUD

class ProfileModel {
    
    var committment: String?
    var committmentRow: Int?
    var college: String?
    var bio: String?
    var idea: String?
    var ideaRow: Int?
    var hackathon: String?
    var skills: [String]?
    
    func fillValues(user: User) {
        committment = user.committment
        committmentRow = committmentIndex(value: (user.committment ?? ""))
        college = user.college
        bio = user.bio
        idea = user.idea
        ideaRow = ideaIndex(value: (user.idea ?? ""))
        hackathon = user.hackathon
    }
    
    func committmentIndex(value: String) -> Int {
        if (value == "High") { return 3 }
        else if value == "Medium" { return 2 }
        else if value == "Low" { return 1 }
        else  { return 0 }
    }
    
    func ideaIndex(value: String) -> Int {
        if (value == "Looking for an idea") { return 2 }
        else if value == "Have an idea" { return 1 }
        else  { return 0 }
    }
}



