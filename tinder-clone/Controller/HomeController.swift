//
//  ViewController.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 25/7/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottonControls = HomeBottomControlsStackView()
    
 
    
    var cardViewModels = [CardViewModel]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        bottonControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        setupFireStoreUserCards()
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    
    fileprivate func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").order(by: "uid")
.start(after: [lastFetchedUser?.uid ?? "" ]).limit(to: 2)
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
                
            })
//            self.setupFireStoreUserCards()
        }
    }
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc func handleSettings() {
        print("Show registration page")
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    fileprivate func setupFireStoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottonControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}

