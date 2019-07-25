//
//  ViewController.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 25/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let greyView = UIView()
        greyView.backgroundColor = .gray
        
        let subViews =  [UIColor.gray, UIColor.darkGray, UIColor.black].map { (color) -> UIView in
            let v = UIView()
            v.backgroundColor = color
            return v
        }
        
        let topStackView = UIStackView(arrangedSubviews: subViews)
        topStackView.distribution = .fillEqually
        
    //    let redView = UIView()
    //  topStackView.backgroundColor = .red
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let blueView = UIView()
        blueView.backgroundColor = .blue
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [topStackView,blueView,yellowView])
    // stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.frame = .init(x: 0, y: 0, width: 300, height: 200)
        
        stackView.fillSuperview()
        
        
        
    }


}

