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

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeController did appear")
        // you want to kick the user out when they log out
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                self.hud.dismiss()
                return
            }
            self.user = user
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let minAge = user?.minSeekingAge ?? 18
        let maxAge = user?.maxSeekingAge ?? 40
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        print("Home controller:", cardViewModel.attributedString)
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    func didSaveSettings() {
        print("Notified of dismissal from SettingsController in HomeController")
        fetchCurrentUser()
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}

