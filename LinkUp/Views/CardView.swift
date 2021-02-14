//
//  CardView.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 26/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
//    var imageUrl: String
    
    var cardViewModel: CardViewModel! {
        didSet {
            swipingPhotosController.cardViewModel = self.cardViewModel
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
    
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let lookingFor = UILabel()
    
    fileprivate let commitment = UILabel()
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
    
    fileprivate let informationLabel = UILabel()
    
    fileprivate let hackathonSkills = UILabel()
    
    // Configurations
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
        
    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width)

        swipingPhotosView.addSubview(imageView)
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
        commitment.font = commitment.font.withSize(14)
        lookingFor.withHeight(100)
        
            
        swipingPhotosView.addSubview(stackView)
        stackView.axis  = NSLayoutConstraint.Axis.vertical

        stackView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: screenSize.width + 20).isActive = true
        
    }
    
    override func layoutSubviews() {
        // in here you know what you CardView frame will be
        gradientLayer.frame = self.frame
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            //
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        // rotation
        // some not that scary math here to convert radians to degrees
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        if shouldDismissCard {
            // hack solution
            guard let homeController = self.delegate as? HomeController else { return }
            
            if translationDirection == 1 {
                homeController.handleLike()
            } else {
                homeController.handleDislike()
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
        
        //        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
        //            if shouldDismissCard {
        //                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
        //            } else {
        //                self.transform = .identity
        //            }
        //
        //        }) { (_) in
        //            self.transform = .identity
        //            if shouldDismissCard {
        //                self.removeFromSuperview()
        //
        //                // reset topCardView inside of HomeController somehow
        //                self.delegate?.didRemoveCard(cardView: self)
        //            }
        //        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
 
