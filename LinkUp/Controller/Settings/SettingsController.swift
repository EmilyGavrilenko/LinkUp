//
//  SettingsController.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 7/8/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
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

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    deinit {
        print("Object is destroying itself properly, no retain cycles or any other memory related issues. Memory being reclaimed properly")
    }
    
    var delegate: SettingsControllerDelegate?
    fileprivate let settingsModel = SettingsModel()
    
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
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            self.user = user
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(imageButton)
        let padding: CGFloat = 16
        imageButton.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        imageButton.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        return header
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "College"
        case 3:
            headerLabel.text = "Major"
        case 4:
            headerLabel.text = "Committment"
        default:
            headerLabel.text = "Bio"
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    let emailTextField: CustomTextField = {
        var tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Name"
        tf.keyboardType = .default
        tf.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        return tf
    }()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter College"
            cell.textField.text = user?.college
            cell.textField.addTarget(self, action: #selector(handleCollegeChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Major"
            cell.textField.text = user?.major
            cell.textField.addTarget(self, action: #selector(handleMajorChange), for: .editingChanged)
        case 4:
            cell.textField.placeholder = "Enter committment"
            cell.textField.text = user?.committment
            cell.textField.addTarget(self, action: #selector(handleCommittmentChange), for: .editingChanged)
        default:
            cell.textField.placeholder = "Enter Bio"
            cell.textField.text = user?.bio
            cell.textField.addTarget(self, action: #selector(handleBioChange), for: .editingChanged)
        }
        
        return cell
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        settingsModel.name = textField.text
    }
    
    @objc fileprivate func handleMajorChange(textField: UITextField) {
        self.user?.major = textField.text
    }
    
    @objc fileprivate func handleCommittmentChange(textField: UITextField) {
        self.user?.committment = textField.text
    }
    
    @objc fileprivate func handleCollegeChange(textField: UITextField) {
        self.user?.college = textField.text
    }
    
    @objc fileprivate func handleBioChange(textField: UITextField) {
        self.user?.bio = textField.text
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
        view.addSubview(verticalStackView)
    }
    
    let nameTextField: SettingsCell.SettingsTextField = {
        let tf = SettingsCell.SettingsTextField()
        tf.placeholder = "Enter Name"
        tf.keyboardType = .default
        tf.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        return tf
    }()
    let majorTextField: SettingsCell.SettingsTextField = {
        let tf = SettingsCell.SettingsTextField()
        tf.placeholder = "Enter major"
        tf.addTarget(self, action: #selector(handleMajorChange), for: .editingChanged)
        return tf
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            nameTextField,
            majorTextField,
            ])
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
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
        // dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        print("Saving our settings data into Firestore")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "college": user?.college ?? "",
            "major": user?.major ?? "",
            "committment": user?.committment ?? "",
            "bio": user?.bio ?? -1,
            "imageUrl": user?.imageUrl ?? "",
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
                self.delegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
}


