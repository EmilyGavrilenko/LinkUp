//
//  User.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 26/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    
    // defining our properties for our model layer
    var name: String?
    var college: String?
    var major: String?
    var committment: String?
    var bio: String?
    var imageUrl: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here
        self.name = dictionary["fullName"] as? String ?? ""
        self.college = dictionary["college"] as? String ?? ""
        self.major = dictionary["major"] as? String ?? ""
        self.committment = dictionary["committment"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = 18
        
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = "Programmer"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]() // empty string array
        if let url = imageUrl { imageUrls.append(url) }
        
        return CardViewModel(uid: self.uid ?? "", imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
