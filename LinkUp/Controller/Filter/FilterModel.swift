//
//  FilterModel.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/14/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//


import Foundation
import Firebase

class FilterModel {
    var college: String?
    var hackathon: String?
    var committment: String?
    var committmentRow: Int?
    var idea: String?
    var ideaRow: Int?
    var skills: [String]?
    
    func fillValues(user: User) {
        college = user.college
        hackathon = user.hackathon
        committment = user.committment
        committmentRow = committmentIndex(value: user.committment!)
        idea = user.idea
        ideaRow = ideaIndex(value: user.idea!)
    }
    
    func fillFilterValues(filters: Filters) {
        college = filters.college
        hackathon = filters.hackathon
        committment = filters.committment
        committmentRow = committmentIndex(value: filters.committment!)
        idea = filters.idea
        ideaRow = ideaIndex(value: filters.idea!)
    }
    
    func committmentIndex(value: String) -> Int {
        if (value == "High") { return 3 }
        else if value == "Medium" { return 2 }
        else if value == "Low" { return 1 }
        else  { return 0 }
    }
    
    func ideaIndex(value: String) -> Int {
        if (value == "Looking for an idea") { return 1 }
        else if value == "Have an idea" { return 2 }
        else  { return 0 }
    }
}

