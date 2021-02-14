//
//  MessagesNavBar.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//


import LBTATools

class MessagesNavBar: UIView {
    
    let primaryColor = UIColor(named: "PrimaryColor") ?? .blue
    let tertiaryColor = UIColor(named: "TertiaryColor")
    let quadraryColor = UIColor(named: "QuadraryColor")
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "jane1.jpg"))
    let nameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16))
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: UIColor(named: "PrimaryColor") ?? .blue)
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: UIColor(named: "PrimaryColor") ?? .blue)
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        
        nameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        //        userProfileImageView.constrainWidth(44)
        //        userProfileImageView.constrainHeight(44)
        //        userProfileImageView.clipsToBounds = true
        //        userProfileImageView.layer.cornerRadius = 44 / 2
        
        let middleStack = hstack(
            stack(
                userProfileImageView,
                nameLabel,
                spacing: 8,
                alignment: .center),
            alignment: .center
        )
        
        hstack(backButton.withWidth(50),
               middleStack,
               flagButton).withMargins(.init(top: 0, left: 4, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
