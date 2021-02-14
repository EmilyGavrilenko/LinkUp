//
//  User.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//


import UIKit

struct User: ProducesCardViewModel {
    
    // defining our properties for our model layer
    var name: String?
    var college: String?
    var major: String?
    var committment: String?
    var bio: String?
    var idea: String?
    var hackathon: String?
    var skills: [String]?
    var imageUrl: String?
    var createdProfile: Bool?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here
        self.name = dictionary["name"] as? String ?? ""
        self.college = dictionary["college"] as? String ?? ""
        self.major = dictionary["major"] as? String ?? ""
        self.committment = dictionary["committment"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.idea = dictionary["idea"] as? String
        self.hackathon = dictionary["hackathon"] as? String ?? ""
        self.skills = dictionary["skills"] as? [String]
        self.major = dictionary["major"] as? String ?? ""
        self.createdProfile = dictionary["createdProfile"] as? Bool ?? false
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n"))
        let collegeString = (NSMutableAttributedString(string: college!))
        collegeString.enumerateAttribute(.font, in: NSRange(0..<collegeString.length)) { value, range, stop in
            collegeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range)
        }
        attributedText.append(collegeString)
        attributedText.append(NSAttributedString(string: "\n"))
        attributedText.append(NSAttributedString(string: bio!))
        
        
        return CardViewModel(uid: self.uid ?? "", imageName: imageUrl!, attributedString: attributedText, textAlignment: .left, idea: idea ?? "", commitment: committment ?? "", hackathon: hackathon ?? "", skills: skills ?? ["Java", "Python", "Git", "Web Dev"])
    }
}
