//
//  CardView.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 26/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

class CardView: UIView {

    fileprivate let imageView = UIImageView(image:#imageLiteral(resourceName: "lady5c"))
    
    // Configurations
    
    fileprivate let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.fillSuperview()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
    
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
           handleEnded(gesture)
        default:
            ()
        }
        
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        // rotation
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer){
      //  let thereshold:CGFloat = 100
        let shouldDismissCardRight = gesture.translation(in: nil).x > threshold
        let shouldDismissCardLeft = gesture.translation(in: nil).x < threshold * -1
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCardRight {
                self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)
            } else if shouldDismissCardLeft {
                self.frame = CGRect(x: -1000, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            self.transform = .identity
            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


 
