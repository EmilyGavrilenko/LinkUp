//
//  SendMessageButtin.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = UIColor(named: "PrimaryColor") ?? #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = UIColor(named: "PrimaryColor") ?? #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }
    
}
