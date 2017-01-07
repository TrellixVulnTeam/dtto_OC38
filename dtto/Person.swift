//
//  Person.swift
//  dtto
//
//  Created by Jitae Kim on 11/18/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import UIKit

struct Person {
    
    var name: String
    var age: Int
    var image: UIImage
    var post: String

    
    init() {
        name = "Jitae"
        age = 23
        image = #imageLiteral(resourceName: "profile")
        post = "Is this working?"
        
    }
    
    init(name: String, image: UIImage) {
        self.name = name
        self.age = 23
        self.image = image
        self.post = "Is this working?"
    }
    
    func getName() -> String {
        return name
    }
    
    func getAge() -> Int {
        return age
    }
    
    func getImage() -> UIImage {
        return image
    }
    func getPost() -> String {
        return post
    }
    
}
