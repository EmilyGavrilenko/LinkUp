////
////  PhotoController.swift
////  tinder-clone
////
////  Created by yash Shelatkar on 19/8/19.
////  Copyright © 2019 yash Shelatkar. All rights reserved.
////
//
//import UIKit
//
//class PhotoController: UIViewController {
//
//    let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
//
//    // provide an initializer that takes in a URL instead
//    init(imageUrl: String) {
//        if let url = URL(string: imageUrl) {
//            imageView.sd_setImage(with: url)
//        }
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imageView.contentMode = .scaleAspectFill
//        let screenSize: CGRect = UIScreen.main.bounds
//        imageView.withWidth(screenSize.width)
//        imageView.withHeight(screenSize.width)
//        view.addSubview(imageView)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

