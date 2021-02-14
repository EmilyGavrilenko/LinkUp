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
            imageView.sd_setImage(with: URL(string: cardViewModel.imageUrl))
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            if (cardViewModel.idea == "") {
                lookingFor.text = "Looking for a project 🔍"
            }
            else {
                lookingFor.text = "Has an idea 💡"
            }
            if (cardViewModel.commitment == "High") {
                commitment.text = "High Commitment ⭐⭐⭐"
            }
            else if (cardViewModel.commitment == "Medium") {
                commitment.text = "Medium Commitment ⭐⭐"
            }
            else {
                commitment.text = "Low Commitment ⭐"
            }
            let hackSkills = NSMutableAttributedString(string: "", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
            let regularAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
            let boldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            if (cardViewModel.hackathon != "") {
                hackSkills.append(NSMutableAttributedString(string: "Hackathons: ", attributes: boldAttributes))
                hackSkills.append(NSMutableAttributedString(string: cardViewModel.hackathon, attributes: regularAttributes))
                hackSkills.append(NSMutableAttributedString(string: "\n", attributes: regularAttributes))

            }
            hackSkills.append(NSMutableAttributedString(string: "Skills:  ", attributes: boldAttributes))
            hackSkills.append(NSMutableAttributedString(string: cardViewModel.skills.joined(separator: ", "), attributes: regularAttributes))
            hackathonSkills.attributedText = hackSkills
        }
    }
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 320)
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame : .zero)
        view.frame = self.view.bounds
        view.contentInsetAdjustmentBehavior = .never
        view.contentSize = contentViewSize
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let lookingFor = UILabel()
    
    fileprivate let commitment = UILabel()
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "jane1"))
    
    fileprivate let informationLabel = UILabel()
    
    fileprivate let hackathonSkills = UILabel()
    
    
        
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.withHeight(50)
        button.withWidth(50)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    fileprivate func setupLayout() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.addSubview(scrollView)
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width)
        scrollView.addSubview(imageView)

        informationLabel.textColor = .black
        informationLabel.numberOfLines = 0
        hackathonSkills.textColor = .black
        hackathonSkills.numberOfLines = 0

        let stackView   = UIStackView()
        let labels   = UIStackView()
        labels.spacing = 10.0
        stackView.spacing = 10.0
        stackView.addArrangedSubview(informationLabel)
        stackView.addArrangedSubview(labels)
        stackView.addArrangedSubview(hackathonSkills)
        labels.axis  = NSLayoutConstraint.Axis.horizontal
        labels.distribution  = UIStackView.Distribution.equalSpacing
        labels.anchor(top: nil, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        let bgColor = UIColor(named: "SecondaryColor")

        labels.addArrangedSubview(lookingFor)
        lookingFor.layer.borderWidth = 1.0
        lookingFor.layer.cornerRadius = 8
        lookingFor.backgroundColor = bgColor
        lookingFor.layer.masksToBounds = true
        lookingFor.contentMode = .scaleToFill
        lookingFor.textAlignment = .center
        lookingFor.numberOfLines = 2
        lookingFor.font = lookingFor.font.withSize(14)
        lookingFor.withHeight(50)
        
        labels.addArrangedSubview(commitment)
        commitment.layer.borderWidth = 1.0
        commitment.layer.cornerRadius = 8
        commitment.backgroundColor = bgColor
        commitment.layer.masksToBounds = true
        commitment.contentMode = .scaleToFill
        commitment.textAlignment = .center
        commitment.numberOfLines = 2
        commitment.font = commitment.font.withSize(15)
        lookingFor.withHeight(100)
        
            
        scrollView.addSubview(stackView)
        stackView.axis  = NSLayoutConstraint.Axis.vertical

        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.width + 20).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
    }
    
    
    @objc fileprivate func handleTapDismiss() {
        print("test")
        self.dismiss(animated: true)
    }
    
}
