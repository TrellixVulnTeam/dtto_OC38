import Foundation
import Stripe
import Firebase

class MyAPIClient: NSObject, STPBackendAPIAdapter {

    static let sharedClient = MyAPIClient()
    let session: URLSession
    var defaultSource: STPCard? = nil
    var sources: [STPCard] = []

    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        self.session = URLSession(configuration: configuration)
        super.init()
    }

    func decodeResponse(_ response: URLResponse?, error: NSError?) -> NSError? {
        if let httpResponse = response as? HTTPURLResponse
            , httpResponse.statusCode != 200 {
            return error ?? NSError.networkingError(httpResponse.statusCode)
        }
        return error
    }

    func completeCharge(_ result: STPPaymentResult, amount: Int, completion: @escaping STPErrorBlock) {

        // upload charge to firebase.
        
        guard let userID = defaults.getUID() else { return }
        let autoID = USERS_REF.child(userID).child("charges").childByAutoId().key
        USERS_REF.child(userID).child("charges").child(autoID).child("amount").setValue(amount, withCompletionBlock: { error,_ in
            
            if let _ = error {
                completion(error)
                return
            }
            
            completion(nil)
            
        })
        
    }
    
    @objc func retrieveCustomer(_ completion: @escaping STPCustomerCompletionBlock) {
        
        // get the customer's info from firebase
        guard let userID = defaults.getUID() else { return }
        
        let userStripeRef = FIREBASE_REF.child("stripe_customers").child(userID)
        userStripeRef.observeSingleEvent(of: .value, with: { snapshot in
            
            // get the user's stripeID
            guard let stripeDict = snapshot.value as? [String:AnyObject], let customerID = stripeDict["customerID"] as? String else { return }
   
            // get the user's list of sources
            if let sourcesDict = stripeDict["sources"] as? [String:[String:AnyObject]] {
                
                // attach each existing source to the customer
                for (_, source) in sourcesDict {

                    if let id = source["id"] as? String, let brand = source["brand"] as? String, let last4 = source["last4"] as? String, let expMonth = source["exp_month"] as? UInt, let expYear = source["exp_year"] as? UInt, let funding = source["funding"] as? String {
                        print("ADDING SOURCE")
                        let card = STPCard(id: id, brand: .visa, last4: last4, expMonth: expMonth, expYear: expYear, funding: .credit)
                        self.sources.append(card)
                        
                    }

                }
            }
            
            let customer = STPCustomer(stripeID: customerID, defaultSource: self.sources.first, sources: self.sources)
            completion(customer, nil)
            print(self.sources.count)
            return
            
        })
    
    }
    
    @objc func selectDefaultCustomerSource(_ source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        
        if let token = source as? STPToken {
            self.defaultSource = token.card
        }

    }
    
    @objc func attachSource(toCustomer source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
        
        if let token = source as? STPToken, let card = token.card {
            self.sources.append(card)
            self.defaultSource = card
            
            //upload to firebase
            guard let userID = defaults.getUID() else { return }
            
            let autoID = FIREBASE_REF.child("stripe_customers").child(userID).child("sources").childByAutoId()
            autoID.child("token").setValue(token.tokenId, withCompletionBlock: { error, reference in
                
                if let error = error {
                    print("set value error")
                    print(error)
                    return
                }
                
                print("successfully added card to firebase")
                completion(nil)
                
            })

        }

    }

}
