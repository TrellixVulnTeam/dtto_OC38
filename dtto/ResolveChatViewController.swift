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

    let resolveTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Was username helpful?"
        return label
    }()
    
    lazy var helpfulButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Helpful", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(helped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var notHelpfulButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("-", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.tintColor = .darkGray
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(notHelped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var addCardButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Add Card", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        return button
    }()
    
    lazy var submitPaymentButton: RoundButton = {
        let button = RoundButton(type: .system)
        button.setTitle("Submit", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(submitCard), for: .touchUpInside)
        return button
    }()
    
    lazy var amountPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        return pickerView
    }()
    
    let paymentContext: STPPaymentContext
    
    init() {
        self.paymentContext = STPPaymentContext(apiAdapter: MyAPIClient())
        super.init(nibName: nil, bundle: nil)
        self.paymentContext.hostViewController = self
        self.paymentContext.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupViews() {
        
        view.backgroundColor = Color.darkNavy
        
//        view.addSubview(helpfulButton)
//        view.addSubview(addCardButton)
        view.addSubview(amountPickerView)
        view.addSubview(submitPaymentButton)
        
//        helpfulButton.anchorCenterSuperview()
//        addCardButton.anchor(top: helpfulButton.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 80)
//        addCardButton.anchorCenterXToSuperview()
//        amountPickerView.
//        submitPaymentButton.anchor(top: addCardButton.bottomAnchor, leading: nil, trailing: nil, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 80)
        submitPaymentButton.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 100, heightConstant: 100)
        submitPaymentButton.anchorCenterSuperview()
        
        
    }
    
    func helped(_ sender: UIButton) {
        
    }
    
    func notHelped(_ sender: UIButton) {
        
    }
    
    func addCard() {
      
//        self.paymentContext.pushPaymentMethodsViewController()
    }
    
    func submitCard() {
        
        self.paymentContext.requestPayment()
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
            print(error)
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

extension ResolveChatViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}
