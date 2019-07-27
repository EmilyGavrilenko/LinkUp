//
//  RegistrationController.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 27/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {

    // UI Components
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
        
    }()
    
    let fullNameTextField : CustomTextField = {
       let tf = CustomTextField(padding: 24)
       tf.placeholder = "Entre Full Name"
        tf.backgroundColor = .white
        
       return tf
    }()
    
    let emailTextField : CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Entre email address"
        tf.backgroundColor = .white
        return tf
    }()

    let passwordTextField : CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Entre password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        return button
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 1, green: 0.4529054165, blue: 0.4463197589, alpha: 0.85)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }

}
