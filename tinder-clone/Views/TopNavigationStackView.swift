//
//  TopNavigationStackView.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 26/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {

    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "ae0aee87-ff7a-4830-94d3-6f19bb64dee3"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       heightAnchor.constraint(equalToConstant: 80).isActive = true
       fireImageView.contentMode = .scaleAspectFit
        
       settingButton.setImage(#imageLiteral(resourceName: "208322b9-6bf3-4241-9cec-17a73e689bac").withRenderingMode(.alwaysOriginal), for: .normal)
       messageButton.setImage(#imageLiteral(resourceName: "9474f3a4-dd2f-4cb9-a225-cb108e4aaeda").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingButton,UIView(),fireImageView,UIView(),messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
