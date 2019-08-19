//
//  HomeBottomControlsStackView.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 25/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "be077009-7a36-471e-a50f-11a4e597829f"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "54797469-b618-491f-88e9-2824221065a6"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "b20a6d9a-233e-46da-bf38-96fdb801b723"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "49eda04c-035b-475c-bf42-c30a344445f5"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "4d860822-2a26-42ed-91f0-9a971494ffdd"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

