//
//  ResolveChatViewController.swift
//  dtto
//
//  Created by Jitae Kim on 1/14/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Stripe

class ResolveChatViewController: UIViewController {

    let thanksLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you for saying jae was helpful! Would you like to send a gift?"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var fiveButton: PaymentAmountButton = {
        let button = PaymentAmountButton(dollarAmount: 5)
        button.setTitle("$5.00", for: .normal)
        return button
    }()
    
    lazy var tenButton: PaymentAmountButton = {
        let button = PaymentAmountButton(dollarAmount: 10)
        button.setTitle("$10.00", for: .normal)
        return button
    }()
    
    lazy var customPaymentTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Enter a specific amount here."
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.textColor = Color.darkNavy
        textField.keyboardType = .decimalPad
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        return textField
    }()
    
    lazy var confirmButton: RoundButton = {
        let button = RoundButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(Color.darkNavy, for: .normal)
        button.backgroundColor = .white
        return button
    }()

    let paymentContext: STPPaymentContext
    
    init() {
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
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }
    
    func setupViews() {
        
        view.backgroundColor = Color.darkNavy
        
        view.addSubview(thanksLabel)
        view.addSubview(fiveButton)
        view.addSubview(tenButton)
        view.addSubview(customPaymentTextField)
        view.addSubview(confirmButton)
        
        thanksLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        fiveButton.anchor(top: thanksLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        tenButton.anchor(top: fiveButton.bottomAnchor, leading: fiveButton.leadingAnchor, trailing: fiveButton.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        customPaymentTextField.anchor(top: tenButton.bottomAnchor, leading: fiveButton.leadingAnchor, trailing: fiveButton.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        confirmButton.anchor(top: customPaymentTextField.bottomAnchor, leading: fiveButton.leadingAnchor, trailing: fiveButton.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    func setupNavBar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func submitCard() {
        paymentContext.requestPayment()
    }
    
}


extension ResolveChatViewController: STPPaymentContextDelegate {
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
//        
//        MyAPIClient.sharedClient.completeCharge(paymentResult, amount: self.paymentContext.paymentAmount, completion: completion)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        print("payment changed")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        switch status {
        case .error:
//            print(error)
            print("ERROR")
        case .success:
            print("Payment successful")
        case .userCancellation:
            return // Do nothing
        }
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("couldn't reach stripe servers")
        _ = self.navigationController?.popViewController(animated: true)
    }

    
}


extension ResolveChatViewController: UITextFieldDelegate {
    
    
}
