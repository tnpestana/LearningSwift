//
//  MenuViewController.swift
//  TnpQuizz
//
//  Created by Tiago Pestana on 02/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController
{
    @IBOutlet weak var btnPlay: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnPlay.layer.cornerRadius = 5
    }
}
