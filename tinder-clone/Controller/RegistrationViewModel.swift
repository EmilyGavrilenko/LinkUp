//
//  RegistrationViewModel.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 4/8/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import UIKit
import Firebase
class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    
    var bindableImage = Bindable<UIImage>()
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
        //        isFormValidObserver?(isFormValid)
    }
   
    func performRegister(completion: @escaping(Error?) -> ()){
        
        guard let email = email, let password = password else {return}
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if let err = err {
                completion(err)
                return
            }
            
            print("Successfully registered user:", res?.user.uid ?? "")
            
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
                    
                    self.bindableIsRegistering.value = false
                    
                    print("Download url of our image is: ", url?.absoluteString ?? "")
                    // download url firestore next lesson
                })
                
            })
        }
        
    }
    
    var bindableIsFormValid = Bindable<Bool>()
   
}
