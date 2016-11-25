//
//  FirebaseService.swift
//  Chain
//
//  Created by Jitae Kim on 10/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase
//import AlamofireImage

class FirebaseService {
    
    static let dataRequest = FirebaseService()

    private var FIREBASE_REF = FIRDatabase.database().reference()
    private var CARD_REF = FIRDatabase.database().reference().child("arcana")

    
    func downloadImage(uid: String, sender: AnyObject) {
        
    }
    
    func incrementLikes(uid: String, increment: Bool) {
        let ref = CARD_REF.child("\(uid)/numberOfLikes")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let base = snapshot.value as? Int else {
                return
            }
            
            if increment {
                ref.setValue(base+1)
            }
            else if base > 0 {
                   ref.setValue(base-1)
            }
            
            
            
        })
    }
    
    
}
