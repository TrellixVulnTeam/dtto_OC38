//
//  ImageHelper.swift
//  dtto
//
//  Created by Jitae Kim on 2/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase
import Kingfisher

extension UIImageView {
    
    func loadProfileImage(_ userID: String) {

        let reference = STORAGE_REF.child("users").child(userID).child("profile.jpg")
        
        reference.downloadURL(completion: { url, error in
            if let error = error {
                // Handle any errors
            }
            else {

                if let url = url {
                    let resource = ImageResource(downloadURL: url, cacheKey: userID)
                    self.kf.setImage(with: resource)

                }
            }
        })
        
    }
}

