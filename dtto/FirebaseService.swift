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

    func incrementCount(ref: DatabaseReference) {
        
        ref.runTransactionBlock({ data -> TransactionResult in
            
            if let chatCount = data.value as? Int {
                data.value = chatCount + 1
            }
            return TransactionResult.success(withValue: data)
            
        })
        
    }
    
    func decrementCount(ref: DatabaseReference) {
    
        ref.runTransactionBlock({ data -> TransactionResult in
            
            if let chatCount = data.value as? Int {
                if chatCount > 0 {
                    data.value = chatCount - 1
                }
            }
            return TransactionResult.success(withValue: data)
            
        })
        
    }

    func removeRequest(requestID: String) {
        guard let userID = defaults.getUID() else { return }
        let requestsRef = FIREBASE_REF.child("requests/\(userID)/\(requestID)")
        requestsRef.removeValue()
        
    }
    
    func startChat(userID: String, chatID: String) {
        USERS_REF.child(userID).child(CHATS_CHILD).child(chatID).setValue(true)
    }
    
    func addOngoingPostChat(userID: String, postID: String) {
        USERS_REF.child(userID).child("ongoingPostChats").child(postID).setValue(true)
    }
    
    func removeOngoingPostChat(userID: String, postID: String) {
        USERS_REF.child(userID).child("ongoingPostChats").child(postID).removeValue()
    }

    
}
