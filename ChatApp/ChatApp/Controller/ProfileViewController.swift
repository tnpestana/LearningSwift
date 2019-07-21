//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 21/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController
{
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        lblName.text = Auth.auth().currentUser?.email
    }
}
