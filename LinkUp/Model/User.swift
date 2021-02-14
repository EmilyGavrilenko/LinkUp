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
<<<<<<< HEAD
<<<<<<< HEAD
        attributedText.append(NSAttributedString(string: "\n"))
        let collegeString = (NSMutableAttributedString(string: college!))
        collegeString.enumerateAttribute(.font, in: NSRange(0..<collegeString.length)) { value, range, stop in
            collegeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range)
        }
//        collegeString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32)], range: NSRange(location: 0, length: 100))
        attributedText.append(collegeString)
        attributedText.append(NSAttributedString(string: "\n"))
        attributedText.append(NSAttributedString(string: bio!))
=======
        
        let collegeText = college ?? ""
        
        attributedText.append(NSAttributedString(string: " " + collegeText, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let bioText = "Programmer"
        attributedText.append(NSAttributedString(string: "\n\(bioText)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
>>>>>>> 77f28fc1b03cfb3fd43a2d1a70ae3aa8e10b91c8
=======
        
        let ageString = 18
        
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = "Programmer"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
>>>>>>> kira
        var imageUrls = [String]() // empty string array
        if let url = imageUrl { imageUrls.append(url) }
        
        return CardViewModel(uid: self.uid ?? "", imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
