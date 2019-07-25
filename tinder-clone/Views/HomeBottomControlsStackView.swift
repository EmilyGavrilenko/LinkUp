//
//  HomeBottomControlsStackView.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 25/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
       
      let subviews = [#imageLiteral(resourceName: "be077009-7a36-471e-a50f-11a4e597829f"),#imageLiteral(resourceName: "54797469-b618-491f-88e9-2824221065a6"),#imageLiteral(resourceName: "b20a6d9a-233e-46da-bf38-96fdb801b723"),#imageLiteral(resourceName: "49eda04c-035b-475c-bf42-c30a344445f5"),#imageLiteral(resourceName: "4d860822-2a26-42ed-91f0-9a971494ffdd")].map { (img) -> UIView in
        
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subviews.forEach { (v) in
            addArrangedSubview(v)
        }
        
        
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
