//
//  CreateEmail.swift
//  dtto
//
//  Created by Jitae Kim on 11/21/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class CreateEmail: UIViewController {

    @IBOutlet weak var myView: UIView! {
        didSet {
            myView.backgroundColor = .white
            myView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var emailTextField: FloatingTextField!
    
    @IBOutlet weak var passwordTextField: FloatingTextField!
    
    @IBOutlet weak var passwordConfirmTextField: FloatingTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myView.bounceAnimate(withDuration: 0.5)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
