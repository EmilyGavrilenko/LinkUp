//
//  CardViewModel.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 26/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// View Model is supposed represent the State of our View
class CardViewModel {
    // we'll define the properties that are view will display/render out
    let uid: String
    let imageUrl: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    let idea: String
    let commitment: String
    let hackathon: String
    let skills: [String]
    
    init(uid: String, imageName: String, attributedString: NSAttributedString, textAlignment: NSTextAlignment, idea: String, commitment: String, hackathon: String, skills: [String]) {
        self.uid = uid
        self.imageUrl = imageName
        self.attributedString = attributedString
        self.textAlignment = textAlignment
        self.idea = idea
        self.commitment = commitment
        self.hackathon = hackathon
        self.skills = skills
    }
}

