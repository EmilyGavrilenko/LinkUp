//
//  Advertiser.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 27/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(uid: "", imageName: posterPhotoName, attributedString: attributedString, textAlignment: .center, idea: "", commitment: "", hackathon: "", skills: [])
    }
}



