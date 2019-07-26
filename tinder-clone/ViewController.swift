//
//  ViewController.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 25/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let bottomStackView = HomeBottomControlsStackView()
    let cardsDeckView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
    }
    // MARK:- Fileprivate Dummy
    fileprivate func setupDummyCards(){
        let cardView = CardView(frame: .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    // MARK:- Fileprivate
    fileprivate func setupLayout(){
        let overAllStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomStackView])
        overAllStackView.axis = .vertical
        view.addSubview(overAllStackView)
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overAllStackView.isLayoutMarginsRelativeArrangement = true
        overAllStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overAllStackView.bringSubviewToFront(cardsDeckView)
    }
}

