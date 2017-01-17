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

    func incrementCount(ref: FIRDatabaseReference) {
        
        ref.runTransactionBlock({ data -> FIRTransactionResult in
            
            if let chatCount = data.value as? Int {
                data.value = chatCount + 1
            }
            return FIRTransactionResult.success(withValue: data)
            
        })
        
    }
    
    func decrementCount(ref: FIRDatabaseReference) {
        
        ref.runTransactionBlock({ data -> FIRTransactionResult in
            
            if let chatCount = data.value as? Int {
                if chatCount > 0 {
                    data.value = chatCount - 1
                }
            }
            return FIRTransactionResult.success(withValue: data)
            
        })
        
    }

    func removeRequest(requestID: String) {
        guard let userID = defaults.getUID() else { return }
        let requestsRef = FIREBASE_REF.child("requests/\(userID)/\(requestID)")
        requestsRef.removeValue()
        
    }
    
    func startChat(ref: FIRDatabaseReference) {
        
        ref.setValue(true)
        
    }


}
