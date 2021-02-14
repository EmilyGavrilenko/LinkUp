//
//  SettingsController.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let primaryColor = UIColor(named: "PrimaryColor")
    let tertiaryColor = UIColor(named: "TertiaryColor")
    let quadraryColor = UIColor(named: "QuadraryColor")
    
    var delegate: SettingsModel?
    fileprivate let settingsModel = SettingsViewModel()
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading User Data"
        hud.show(in: self.view)
        
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                hud.dismiss()
                return
            }
            self.user = user
            self.loadUserPhoto()
            self.settingsModel.fillValues(user: self.user!)
            self.setupLayout()
            hud.dismiss()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        fetchCurrentUser()
        setupGradientLayer()
        setupTapGesture()
        setupBindables()
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStackView)
        
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 120, left: 50, bottom: 50, right: 50))
        //scrollView.isLayoutMarginsRelativeArrangement = true
        //verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            imageButton,
            createLabel(name: "Name"),
            getNameTextField(),
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
        sv.frame.size = contentViewSize
        sv.spacing = 12
        return sv
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200) //Step One
    
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame : .zero)
        view.frame = self.view.bounds
        //view.contentInsetAdjustmentBehavior = .never
        view.contentSize = contentViewSize
        return view
    }()
    
    
    fileprivate func setupNavigationItems() {
            navigationItem.title = "Settings"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
                UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            ]
        }
    
    fileprivate func loadUserPhoto() {
        if let imageUrl = user?.imageUrl, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    // instance properties
    lazy var imageButton = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton) {
        print("Select photo with button:", button)
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        // how do i set the image on my buttons when I select a photo?
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            if let err = err {
                hud.dismiss()
                print("Failed to upload image to storage:", err)
                return
            }
            
            print("Finished uploading image")
            ref.downloadURL(completion: { (url, err) in
                
                hud.dismiss()
                
                if let err = err {
                    print("Failed to retrieve download URL:", err)
                    return
                }
                
                print("Finished getting download url:", url?.absoluteString ?? "")
                
                self.user?.imageUrl = url?.absoluteString
            })
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.withHeight(300)
        return button
    }
    
    func getNameTextField() -> CustomTextField {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Name"
        tf.text = user?.name
        tf.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        return tf
    }
    
    func getCollegeTextField() -> CustomTextField {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Name"
        tf.text = user?.college
        tf.addTarget(self, action: #selector(handleCollegeChange), for: .editingChanged)
        return tf
    }
    
    func getIdeaPicker() -> UIPickerView {
        let ideaPicker: UIPickerView = UIPickerView()
        ideaPicker.delegate = self as UIPickerViewDelegate
        ideaPicker.dataSource = self as UIPickerViewDataSource
        ideaPicker.center = self.view.center
        ideaPicker.withHeight(100)
        ideaPicker.selectRow(settingsModel.ideaRow ?? 0, inComponent: 0, animated: true)
        ideaPicker.tag = 1
        return ideaPicker
    }
    
    func getCommittmentPicker() -> UIPickerView {
        let ideaPicker: UIPickerView = UIPickerView()
        ideaPicker.delegate = self as UIPickerViewDelegate
        ideaPicker.dataSource = self as UIPickerViewDataSource
        ideaPicker.center = self.view.center
        ideaPicker.withHeight(100)
        ideaPicker.selectRow(settingsModel.committmentRow ?? 0, inComponent: 0, animated: true)
        ideaPicker.tag = 2
        return ideaPicker
    }
    
    func getBioTextField() -> CustomTextField {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Bio"
        tf.keyboardType = .alphabet
        tf.text = user?.bio
        tf.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        return tf
    }
    
    func getHackathonTextField() -> CustomTextField {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Hackathon"
        tf.text = user?.hackathon
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
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        settingsModel.name = textField.text
    }
    @objc fileprivate func handleCollegeChange(textField: UITextField) {
        settingsModel.college = textField.text
    }
    @objc fileprivate func handleHackathonChange(textField: UITextField) {
        settingsModel.hackathon = textField.text
    }
    @objc fileprivate func handleBioChange(textField: UITextField) {
        settingsModel.bio = textField.text
    }
    @objc fileprivate func handleSkillChange(textField: UITextField) {
        print("Editing Skill")
    }
    
    
    @objc fileprivate func handleLogout() {
        do {
            try Auth.auth().signOut()
            print("Logging out")
            var loginDelegate: LoginControllerDelegate?
            let loginController = LoginController()
            loginController.delegate = loginDelegate
            navigationController?.pushViewController(loginController, animated: true)
        }
        catch {
            print("already logged out")
        }
    }
    
    @objc fileprivate func handleSave() {
        print("Saving our settings data into Firestore")
        print("Have idea \(settingsModel.idea)")
        print("Committment \(settingsModel.committment)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "name": settingsModel.name ?? "",
            "college": settingsModel.college ?? "",
            "hackathon": settingsModel.hackathon ?? "",
            "bio": settingsModel.bio ?? "",
            "committment": settingsModel.committment ?? "",
            "idea": settingsModel.idea ?? "",
            "imageUrl": user!.imageUrl ?? "",
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings:", err)
                return
            }
            
            print("Finished saving user info")
            self.dismiss(animated: true, completion: {
                print("Dismissal complete")
            })
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    fileprivate func setupBindables() {
        settingsModel.checkFormValidity()
        settingsModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.saveButton.isEnabled = isFormValid
            self.saveButton.backgroundColor = isFormValid ? quadraryColor : .lightGray
            self.saveButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
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
            settingsModel.idea = pickerData1[row]
        }
        
        if pickerView.tag == 2 {
            settingsModel.committment = pickerData2[row]
        }
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
}
