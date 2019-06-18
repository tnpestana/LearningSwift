//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController
{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func registerTapped(_ sender: Any)
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
        
        Auth.auth().createUser(withEmail: email, password: password)
        { (user, error) in
            if let error = error
            {
                self.showAlert(message: error.localizedDescription)
            }
            else
            {
                print("registration successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
}
