//
//  Filters.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/14/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//

import UIKit

struct Filters {
    
    var uid: String?
    var college: String?
    var committment: String?
    var idea: String?
    var hackathon: String?
    
    var skills: [String]?
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.college = dictionary["college"] as? String ?? ""
        self.committment = dictionary["committment"] as? String ?? ""
        self.idea = dictionary["idea"] as? String
        self.hackathon = dictionary["hackathon"] as? String ?? ""
        
        self.skills = dictionary["skills"] as? [String]
    }
}
