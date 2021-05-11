//
//  Networking.swift
//  BitcoinPriceTrackerApp
//
//  Created by Tiago Pestana on 15/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Networking
{
    let headers: HTTPHeaders = ["X-signature" : "timestamp.public_key.digest_value"]
    
    let API_URL: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let RESULT_CURRENCY: String = "BTC"
    
    func getBtcValue(currency: String, onComplete: @escaping (String) -> ())
    {
        let finalUrl = API_URL + RESULT_CURRENCY + currency
        print(finalUrl)
        Alamofire.request(finalUrl, method: .get).responseJSON
        { response in
            if response.result.isSuccess
            {
                let json: JSON = JSON(response.result.value!)
                let todaysAverage: String = json["ask"].stringValue
                onComplete(todaysAverage)
            }
            else
            {
                print(response.result.error!)
            }
        }
    }
}
