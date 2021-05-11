//
//  ChangeLocationViewController.swift
//  WeatherApp
//
//  Created by Tiago Pestana on 08/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit

protocol ChangeLocationDelegate
{
    func newLocationChosen(city: String)
}

class ChangeLocationViewController: UIViewController
{
    
    @IBOutlet weak var txtGetWeather: UITextField!
    @IBOutlet weak var btnGetWeather: UIButton!
    
    var delegate: ChangeLocationDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getWeather(_ sender: Any)
    {
        if let city = txtGetWeather.text
        {
            delegate?.newLocationChosen(city: city)
            goBack(self)
        }
    }
}
