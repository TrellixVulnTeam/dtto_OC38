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

    func startChat(ref: FIRDatabaseReference) {
        
        ref.setValue(true)
        
    }

}
