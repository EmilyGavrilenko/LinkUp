//
//  SettingsModel.swift
//  tinder-clone
//
//  Created by Emily Gavrilenko on 2/13/21.
//  Copyright © 2021 yash Shelatkar. All rights reserved.
//

import UIKit
import Firebase

class SettingsModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var name: String? { didSet { checkFormValidity() } }
    var committment: String? { didSet { checkFormValidity() } }
    var college: String? { didSet { checkFormValidity() } }
    var major: String? { didSet { checkFormValidity() } }
    var bio: String? { didSet { checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = name?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
//    func performRegistration(completion: @escaping (Error?) -> ()) {
//        bindableIsRegistering.value = true
//        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
//            if let err = err {
//                completion(err)
//                return
//            }
//
//            print("Successfully registered user:", res?.user.uid ?? "")
//            self.saveImageToFirebase(completion: completion)
//        }
//    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) ->()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                completion(err)
                return // bail
            }
            
            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
            
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String : Any] = [
            "fullName": name ?? "",
            "uid": uid,
            "imageUrl": imageUrl ?? "",
            "committment": committment ?? "",
            "college": college ?? "",
            "major": major ?? "",
            "bio": bio ?? "",
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            self.bindableIsRegistering.value = false
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
}

