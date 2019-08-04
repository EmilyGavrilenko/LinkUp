//
//  Bindable.swift
//  tinder-clone
//
//  Created by yash Shelatkar on 4/8/19.
//  Copyright © 2019 yash Shelatkar. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
