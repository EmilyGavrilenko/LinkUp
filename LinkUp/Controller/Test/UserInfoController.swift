//
//  UserInfoController.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class UserInfoController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    let primaryColor = UIColor(named: "PrimaryColor")
    let tertiaryColor = UIColor(named: "TertiaryColor")
    let quadraryColor = UIColor(named: "QuadraryColor")
    
    fileprivate let userDetailsModel = UserDetailsModel()
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading Data"
        hud.show(in: self.view)
        
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                hud.dismiss()
                return
            }
            print("Found user")
            print(user!)
            self.user = user
            self.setupLayout()
            
            hud.dismiss()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading view")
        fetchCurrentUser()
        setupGradientLayer()
        setupTapGesture()
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        view.addSubview(UIButton(title: "Hello", titleColor: .red))
<<<<<<< HEAD
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
=======
        //verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        //verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
>>>>>>> 66e710bd714c19218e7165b531748302a785dcc3
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            createLabel(name: "College"),
            getCollegeTextField(),
            createLabel(name: "Hackathon"),
            getHackathonTextField(),
            createLabel(name: "Bio"),
            getBioTextField(),
            createLabel(name: "Committment"),
            getCommittmentPicker(),
            createLabel(name: "Do you have an project idea?"),
            getIdeaPicker(),
            saveButton,
            ])
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
    @objc fileprivate func handleSave() {
        print("Saving our settings data into Firestore")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "college": userDetailsModel.college ?? "",
            "hackathon": userDetailsModel.hackathon ?? "",
            "bio": userDetailsModel.bio ?? "",
            "committment": userDetailsModel.committment ?? "",
            "idea": userDetailsModel.idea ?? "",
<<<<<<< HEAD
=======
            "createdProfile": true,
>>>>>>> 66e710bd714c19218e7165b531748302a785dcc3
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Profile"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData, merge: true) { (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings:", err)
                return
            }
        
            self.dismiss(animated: true, completion: {
                print("Dismissal complete")
            })
        }
    }
    
    func getCollegeTextField() -> CustomTextField {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Name"
        tf.addTarget(self, action: #selector(handleCollegeChange), for: .editingChanged)
        return tf
    }
    
    func getIdeaPicker() -> UIPickerView {
        let ideaPicker: UIPickerView = UIPickerView()
        ideaPicker.delegate = self as UIPickerViewDelegate
        ideaPicker.dataSource = self as UIPickerViewDataSource
        ideaPicker.center = self.view.center
        ideaPicker.withHeight(100)
<<<<<<< HEAD
        ideaPicker.selectRow(userDetailsModel.ideaRow ?? 0, inComponent: 0, animated: true)
=======
>>>>>>> 66e710bd714c19218e7165b531748302a785dcc3
        ideaPicker.tag = 1
        return ideaPicker
    }
    
    func getCommittmentPicker() -> UIPickerView {
        let ideaPicker: UIPickerView = UIPickerView()
        ideaPicker.delegate = self as UIPickerViewDelegate
        ideaPicker.dataSource = self as UIPickerViewDataSource
        ideaPicker.center = self.view.center
        ideaPicker.withHeight(100)
<<<<<<< HEAD
        ideaPicker.selectRow(userDetailsModel.committmentRow ?? 0, inComponent: 0, animated: true)
=======
>>>>>>> 66e710bd714c19218e7165b531748302a785dcc3
        ideaPicker.tag = 2
        return ideaPicker
    }
    
    func getBioTextField() -> CustomTextField {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Bio"
        tf.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        return tf
    }
    
    func getHackathonTextField() -> CustomTextField {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Hackathon"
        tf.addTarget(self, action: #selector(handleHackathonChange), for: .editingChanged)
        return tf
    }
    
    func createLabel(name: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height:15))
        label.textAlignment = .left
        label.text = name
        return label
    }
    
    func addSkill() {
        saveButton.removeFromSuperview()
        let skillView = UIStackView()
        skillView.axis = .horizontal
        let tf = CustomTextField(padding: 24, height: 50)
        var myField: UITextField = UITextField (frame:CGRect(x: 10, y: 10, width: 30, height: 45));
        tf.placeholder = "Enter Skill"
        tf.addTarget(self, action: #selector(handleSkillChange), for: .editingChanged)
        
//        self.addArrangedSubview(myField)
//        stackView.addArrangedSubview(saveBtn)
//        stackView.addArrangedSubview(error)
    }
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = UIColor(named: "QuadraryColor")
        button.setTitleColor(.gray, for: .disabled)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleCollegeChange(textField: UITextField) {
        userDetailsModel.college = textField.text
    }
    @objc fileprivate func handleHackathonChange(textField: UITextField) {
        userDetailsModel.hackathon = textField.text
    }
    @objc fileprivate func handleBioChange(textField: UITextField) {
        userDetailsModel.bio = textField.text
    }
    @objc fileprivate func handleSkillChange(textField: UITextField) {
        print("Editing Skill")
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = primaryColor?.cgColor
        let bottomColor = tertiaryColor?.cgColor
        // make sure to user cgColor
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    var pickerData1 = ["N/A", "Have an idea", "Looking for an idea"]
    var pickerData2 = ["N/A", "Low", "Medium", "High"]
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
                return pickerData1.count
        }
        else {
            return pickerData2.count
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
                return pickerData1[row]
        }
        else {
            return pickerData2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            userDetailsModel.idea = pickerData1[row]
        }
        
        if pickerView.tag == 2 {
            userDetailsModel.committment = pickerData2[row]
        }
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
}
