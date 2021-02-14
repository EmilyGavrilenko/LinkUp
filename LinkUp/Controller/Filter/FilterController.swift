//
//  FilterController.swift
//  LinkUp
//
//  Created by Emily Gavrilenko on 2/14/21.
//  Copyright © 2021 Emily and Kira. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

protocol FilterControllerDelegate {
    func getFilters()
}

class FilterController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let primaryColor = UIColor(named: "PrimaryColor")
    let tertiaryColor = UIColor(named: "TertiaryColor")
    let quadraryColor = UIColor(named: "QuadraryColor")
    
    fileprivate let filterModel = FilterModel()
    var user: User?
    var filters: Filters?
    var delegate: FilterControllerDelegate?
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            self.user = user
            self.filterModel.fillValues(user: self.user!)
            self.setupLayout()
        }
    }
    
    func fetchFilters() {
        guard let uid = Auth.auth().currentUser?.uid else {
            fetchCurrentUser()
            return
        }
        Firestore.firestore().collection("filters").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("failed to fetch filters for currently logged in user:", err)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            self.filters = Filters(dictionary: dictionary)
            print("Filters: ")
            print(self.filters!)
            self.filterModel.fillFilterValues(filters: self.filters!)
            self.setupLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilters()
        setupGradientLayer()
        setupTapGesture()
    }
    
    lazy var getCollegeTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter College"
        tf.text = filterModel.college
        tf.addTarget(self, action: #selector(handleCollegeChange), for: .editingChanged)
        return tf
    }()
    
    lazy var getIdeaPicker: UIPickerView = {
        let ideaPicker: UIPickerView = UIPickerView()
        ideaPicker.delegate = self as UIPickerViewDelegate
        ideaPicker.dataSource = self as UIPickerViewDataSource
        ideaPicker.center = self.view.center
        ideaPicker.withHeight(100)
        ideaPicker.selectRow(filterModel.ideaRow ?? 0, inComponent: 0, animated: true)
        ideaPicker.tag = 1
        return ideaPicker
    }()
    
    lazy var getCommittmentPicker: UIPickerView = {
        let ideaPicker: UIPickerView = UIPickerView()
        ideaPicker.delegate = self as UIPickerViewDelegate
        ideaPicker.dataSource = self as UIPickerViewDataSource
        ideaPicker.center = self.view.center
        ideaPicker.withHeight(100)
        ideaPicker.selectRow(filterModel.committmentRow ?? 0, inComponent: 0, animated: true)
        ideaPicker.tag = 2
        return ideaPicker
    }()
    
    lazy var getHackathonTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Hackathon"
        tf.text = filterModel.hackathon
        tf.addTarget(self, action: #selector(handleHackathonChange), for: .editingChanged)
        return tf
    }()
    
    func createLabel(name: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height:15))
        label.textAlignment = .left
        label.text = name
        return label
    }
    
    func createPageLabel(name: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height:40))
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
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
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = UIColor(named: "QuadraryColor")
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let clearAllBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Filters", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        return button
    }()
    
    func hackathonField() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [
            getHackathonTextField,
            clearHackathonBtn()
            ])
        sv.axis = .horizontal
        return sv
    }
    
    func clearHackathonBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.withHeight(50)
        btn.withWidth(50)
        btn.addTarget(self, action: #selector(clearHackathon), for: .touchUpInside)
        return btn
    }
    
    @objc fileprivate func clearHackathon() {
        filterModel.hackathon = ""
        getHackathonTextField.text = ""
    }

    
    func collegeField() -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [
            getCollegeTextField,
            clearCollegeBtn()
            ])
        sv.axis = .horizontal
        return sv
    }
    
    func clearCollegeBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.withHeight(50)
        btn.withWidth(50)
        btn.addTarget(self, action: #selector(clearCollege), for: .touchUpInside)
        return btn
    }
    
    @objc fileprivate func clearCollege() {
        filterModel.college = ""
        getCollegeTextField.text = ""
    }
    
    @objc fileprivate func clearAll() {
        filterModel.college = ""
        getCollegeTextField.text = ""
        filterModel.hackathon = ""
        getHackathonTextField.text = ""
        filterModel.committment = ""
        getCommittmentPicker.selectRow(0, inComponent: 0, animated: true)
        filterModel.idea = ""
        getIdeaPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            createPageLabel(name: "Filter By:"),
            createLabel(name: "College"),
            collegeField(),
            createLabel(name: "Hackathon"),
            hackathonField(),
            createLabel(name: "Committment"),
            getCommittmentPicker,
            createLabel(name: "My ideal partner:"),
            getIdeaPicker,
            clearAllBtn,
            saveButton,
            cancelButton,
            ])
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
    @objc fileprivate func handleCollegeChange(textField: UITextField) {
        filterModel.college = textField.text
    }
    @objc fileprivate func handleHackathonChange(textField: UITextField) {
        filterModel.hackathon = textField.text
    }
    @objc fileprivate func handleSkillChange(textField: UITextField) {
        print("Editing Skill")
    }
    
    @objc fileprivate func handleSave() {
        print("Saving our settings data into Firestore")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "college": filterModel.college ?? "",
            "hackathon": filterModel.hackathon ?? "",
            "committment": filterModel.committment ?? "",
            "idea": filterModel.idea ?? "",
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving filters"
        hud.show(in: view)
        Firestore.firestore().collection("filters").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user filter settings:", err)
                return
            }
            
            print("Finished saving user filter settings")
            
            self.dismiss(animated: true, completion: {
                self.delegate?.getFilters()
            })
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
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    var pickerData1 = ["N/A", "Has an idea", "Is looking for an idea"]
    var pickerData2 = ["N/A", "Low", "Medium", "High"]
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
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
            filterModel.idea = pickerData1[row] == "N/A" ? "" : pickerData1[row]
        }
        
        if pickerView.tag == 2 {
            filterModel.committment = pickerData2[row] == "N/A" ? "" : pickerData2[row]
        }
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
}
