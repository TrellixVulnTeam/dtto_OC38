//
//  CheckoutViewController.swift
//  dtto
//
//  Created by Jitae Kim on 2/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import NVActivityIndicatorView

fileprivate enum Row: Int {
    case Five
    case Ten
    case Fifteen
}

class CheckoutViewController: UIViewController {

    weak var paymentConfirmationDelegate: PaymentConfirmationProtocol?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
//        tableView.allowsMultipleSelection = false
        tableView.register(PaymentCell.self, forCellReuseIdentifier: "PaymentCell")
        return tableView
    }()
    
    lazy var confirmPaymentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = .white
        button.backgroundColor = Color.lightGreen
        button.addTarget(self, action: #selector(confirmPayment), for: .touchUpInside)
        return button
    }()
    
    fileprivate var selectedAmount: Row? {
        didSet {
            
            switch selectedAmount! {
            case .Five:
                paymentContext.paymentAmount = 500
            case .Ten:
                paymentContext.paymentAmount = 1000
            case .Fifteen:
                paymentContext.paymentAmount = 1500
            }
            confirmPaymentButton.fadeIn(withDuration: 0.2)
        }
    }
    
    let helperID: String
    let helperName: String
    let paymentContext: STPPaymentContext
    
    let activityIndicator: NVActivityIndicatorView = {
        let spinner = NVActivityIndicatorView(frame: .zero, type: .ballScaleRippleMultiple, color: .white, padding: 0)
        return spinner
    }()
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.confirmPaymentButton.isUserInteractionEnabled = false
                    self.confirmPaymentButton.setTitle("", for: UIControlState())
//                    self.confirmPaymentButton.sett
//                    self.confirmPaymentButton.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.confirmPaymentButton.isUserInteractionEnabled = true
                    self.confirmPaymentButton.setTitle("Confirm", for: UIControlState())
//                    self.confirmPaymentButton.alpha = 1
                }
            }, completion: nil)
        }
    }

    
    init(helperID: String, helperName: String) {
        self.helperID = helperID
        self.helperName = helperName
        paymentContext = STPPaymentContext(apiAdapter: MyAPIClient())
        super.init(nibName: nil, bundle: nil)
        paymentContext.hostViewController = self
        paymentContext.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(confirmPaymentButton)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 180)
        
        confirmPaymentButton.alpha = 0
        confirmPaymentButton.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 60)
        confirmPaymentButton.anchorCenterXToSuperview()
        
        confirmPaymentButton.addSubview(activityIndicator)
        activityIndicator.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
        activityIndicator.anchorCenterSuperview()
        
    }
    
    func confirmPayment() {
        paymentInProgress = true
        paymentContext.requestPayment()
    }

}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }

        switch row {
        case .Five:
            cell.amountLabel.text = "$5.00"
        case .Ten:
            cell.amountLabel.text = "$10.00"
        case .Fifteen:
            cell.amountLabel.text = "$15.00"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = Row(rawValue: indexPath.row) else { return }
        selectedAmount = row
//        let cell = tableView.cellForRow(at: indexPath) as! PaymentCell
//        cell.amountLabel.textColor = .white
        
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//        let cell = tableView.cellForRow(at: indexPath) as! PaymentCell
//        cell.amountLabel.textColor = .black
//    }
    
}
//extension CheckoutViewController: DisplayBanner {
//    
//}
extension CheckoutViewController: STPPaymentContextDelegate {
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        let ref = FIREBASE_REF.child("users").child(helperID).child("stripeID")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if let stripeID = snapshot.value as? String {
                MyAPIClient.sharedClient.completeCharge(paymentResult, amount: self.paymentContext.paymentAmount, helperID: "tw2QiARnU7ZFZ7we4tmKs3HcSU42", stripeID: stripeID, completion: completion)
            }
            
            else {
//                self.displayBanner(desc: "\(self.helperName) has no Stripe account set up to receive transfers:(", color: UIColor.red)
                self.paymentInProgress = false
            }
            
        })
        
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        print("payment changed")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        switch status {
        case .error:
            print(error!)
            confirmPaymentButton.isUserInteractionEnabled = true
        case .success:
            print("Payment successful")
            
            dismiss(animated: true, completion: {
                self.paymentConfirmationDelegate?.displayPaymentConfirmation()
            })
        case .userCancellation:
            confirmPaymentButton.isUserInteractionEnabled = true
            return // Do nothing
        }
        paymentInProgress = false

    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("couldn't reach stripe servers")
        
        let ac = UIAlertController(title: "Payment failed :(", message: "Could not reach Stripe server", preferredStyle: .alert)
        ac.view.tintColor = Color.darkNavy
        
        let confirmAction = UIAlertAction(title: "Ok", style: .destructive, handler: { action in
            ac.dismiss(animated: true, completion: {
                _ = self.navigationController?.popViewController(animated: true)
            })
            
        })
        
        ac.addAction(confirmAction)

        self.present(ac, animated: true, completion: {
            ac.view.tintColor = Color.darkNavy
        })
        
        
    }
    
    
}
