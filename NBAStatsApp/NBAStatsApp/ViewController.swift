//
//  ViewController.swift
//  NBAStatsApp
//
//  Created by Tiago Pestana on 10/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController
{
    let API_KEY = "c0c4fb5811mshd575afce09783fep109758jsna6fb51f722aa"
    
    let API_ENDPOIT = "https://api-nba-v1.p.rapidapi.com/"
    let STANDINGS_ENDPOINT = "standings/standard/2018"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let headers: HTTPHeaders = ["X-RapidAPI-Key" : API_KEY]
        
        //let parameters: [String : String] = ["league" : "standard", "year" : "2018"]
        
        Alamofire.request(API_ENDPOIT + STANDINGS_ENDPOINT, method: .get, headers: headers).responseJSON
            { (response) in
                if response.result.isSuccess
                {
                    let standingsJSON: JSON = JSON(response.result.value!)
                    print("succeeded")
                    print(standingsJSON)
                }
                else
                {
                    print("failed")
                }
            }
    }
}

