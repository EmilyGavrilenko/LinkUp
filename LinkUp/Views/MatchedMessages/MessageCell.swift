//
//  MessageCell.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//


import LBTATools

class MessageCell: LBTAListCell<Message> {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.9005706906, green: 0.9012550712, blue: 0.9006766677, alpha: 1))
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            
            if item.isFromCurrentLoggedUser {
                // right edge
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.1471898854, green: 0.8059007525, blue: 0.9965714812, alpha: 1)
                textView.textColor = .white
            } else {
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.9005706906, green: 0.9012550712, blue: 0.9006766677, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.trailing?.constant = -20
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
