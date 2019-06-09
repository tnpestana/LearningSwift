//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tiago Pestana on 08/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

class MainViewController: UIViewController
{
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    
    let apikey = "8c3536992559ac53a6323e6f7efcc2cc"
    let endpoint = "http://api.openweathermap.org"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

