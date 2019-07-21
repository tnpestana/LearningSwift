//
//  ChatsListViewController.swift
//  ChatApp
//
//  Created by Tiago Pestana on 21/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class ChatsListViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "segueToChat", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.performSegue(withIdentifier: "segueToChat", sender: self)
    }
}
