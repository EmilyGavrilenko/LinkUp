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

class HomeController: UIViewController, ProfileControllerDelegate, FilterControllerDelegate, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]() // empty array
    var filters: Filters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.moreInfoButton.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        bottomControls.filterButton.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
    }
    
    @objc fileprivate func handleMessages() {
        let vc = MatchesMessagesController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeController did appear")
        // you want to kick the user out when they log out
        if Auth.auth().currentUser == nil {
            print("Auth user is nil")
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
        print("Fetching current user")
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                self.hud.dismiss()
                return
            }
            self.user = user
            print("Got user")
            if (user!.createdProfile ?? false) == false {
                self.handleProfile()
            }
            else {
                print("Going to get filters")
                self.getFilters()
            }
        }
    }
    
    @objc func handleProfile() {
        let profileController = ProfileController()
        profileController.delegate = self
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true)
    }
    
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("failed to fetch swipes info for currently logged in user:", err)
                return
            }
            
            let data = snapshot?.data() as? [String: Int] ?? [:]
            self.swipes = data
            self.getFilters()
        }
    }
    
    func getFilters() {
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("filters").document(uid).getDocument { (snapshot, err) in
            print("Inside get document")
            if let err = err {
                print("failed to fetch filters for currently logged in user:", err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self.filters = Filters(dictionary: dictionary)
            
            self.fetchUsersFromFirestore()
        }
    }
    
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        getFilters()
    }
    
    @objc fileprivate func handleMoreInfo() {
        didTapMoreInfo(cardViewModel: (topCardView?.cardViewModel)!)
    }
    
    @objc fileprivate func handleFilter() {
        let filterController = FilterController()
        filterController.delegate = self
        let navController = UINavigationController(rootViewController: filterController)
        present(navController, animated: true)
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let db = Firestore.firestore()
        var query = db.collection("users").limit(to: 20)
        if (filters?.college ?? "") != "" {
            print("Quering by college \(filters?.college)")
            query = query.whereField("college", isEqualTo: filters?.college)
        }
        if (filters?.hackathon ?? "") != "" {
            print("Quering by hackathon \(filters?.hackathon)")
            query = query.whereField("hackathon", isEqualTo: filters?.hackathon)
        }
        if (filters?.committment ?? "") != "" {
            print("Quering by committment \(filters?.committment)")
            query = query.whereField("committment", isEqualTo: filters?.committment)
        }
        if (filters?.idea ?? "") != "" {
            print("Quering by idea \(filters?.idea)")
            query = query.whereField("idea", isEqualTo: filters?.idea)
        }
        
        topCardView = nil
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch filters:", err)
                return
            }
            
            // we are going to set up the nextCardView relationship for all cards somehow?
            
            // Linked List
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                
                let user = User(dictionary: userDictionary)
                
                self.users[user.uid ?? ""] = user
                
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                //                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore  {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    var users = [String: User]()
    
    var topCardView: CardView?
    
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document:", err)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    print("Successfully updated swipe....")
                    
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    print("Successfully saved swipe....")
                    
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        // How to detect our match between two users?
        print("Detecting match")
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch document for card user:", err)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            print(data)
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                print("Has matched")
                self.presentMatchView(cardUID: cardUID)
                
                guard let cardUser = self.users[cardUID] else { return }
                
                let data = ["name": cardUser.name ?? "", "profileImageUrl": cardUser.imageUrl ?? "", "uid": cardUID, "timestamp": Timestamp(date: Date())] as [String : Any]
                Firestore.firestore().collection("matches_messages").document(uid).collection("matches").document(cardUID).setData(data, completion: { (err) in
                    if let err = err {
                        print("Failed to save match info:", err)
                    }
                })
                
                guard let currentUser = self.user else { return }
                
                let otherMatchData = ["name": currentUser.name ?? "", "profileImageUrl": currentUser.imageUrl ?? "", "uid": currentUser.uid
                    ?? "", "timestamp": Timestamp(date: Date())] as [String : Any]
                Firestore.firestore().collection("matches_messages").document(cardUID).collection("matches").document(uid).setData(otherMatchData, completion: { (err) in
                    if let err = err {
                        print("Failed to save match info:", err)
                    }
                })
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
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
