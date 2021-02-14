//
//  UserDetailsController.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 19/8/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    

    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        view.backgroundColor = .black
        return view
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 320) //Step One

    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame : .zero)
        view.frame = self.view.bounds
        view.contentInsetAdjustmentBehavior = .never
        view.contentSize = contentViewSize
        view.backgroundColor = .white
        return view
    }()
    
    lazy var verticalStackView: UIStackView = {
         let sv = UIStackView(arrangedSubviews: [
            swipingView, dismissButton, scrollView
             ])
         sv.axis = .vertical
         sv.frame.size = contentViewSize
         sv.spacing = 12
         return sv
     }()
    
    let swipingPhotosController = SwipingPhotosController()
    let swipingView = SwipingPhotosController().view!
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        let screenSize: CGRect = UIScreen.main.bounds
        return label
    }()
        
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.withHeight(50)
        button.withWidth(50)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(verticalStackView)
        
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 120, left: 50, bottom: 50, right: 50))
    }
    
    
    @objc fileprivate func handleTapDismiss() {
        print("test")
        self.dismiss(animated: true)
    }
    
}
