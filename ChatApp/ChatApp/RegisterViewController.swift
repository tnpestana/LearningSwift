//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 16/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController
{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        Auth.auth().createUser(withEmail: email, password: password)
        { (user, error) in
            if let error = error
            {
                print("error: \(error.localizedDescription)")
            }
            else
            {
                print("registration successful")
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
