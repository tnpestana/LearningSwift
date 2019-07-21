//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController
{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: Any)
    {
        guard let email = txtEmail.text else
        {
            print("E-mail input is empty")
            return
        }
        
        guard let password = txtPassword.text else
        {
            print("Password input is empty")
            return
        }
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email, password: password)
        { (result, error) in
            if let error = error
            {
                self.showAlert(message: error.localizedDescription)
            }
            else
            {
                print("log in successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
}
