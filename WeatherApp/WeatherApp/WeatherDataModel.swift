//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Tiago Pestana on 10/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import Foundation
import UIKit

class WeatherDataModel
{
    var temperature: Double = 0.0
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    
    func getWeatherIcon(id: Int) -> UIImage?
    {
        var icon: UIImage?
        
        switch id
        {
        case 200, 201, 202, 210, 211, 212, 221, 230, 231, 232:
            icon = UIImage(named: "thunder")
        case 500, 501, 502, 503, 504, 511, 520, 521, 522, 531:
            icon = UIImage(named: "rainy")
        case 600, 601, 602, 611, 612, 613, 615, 616, 620, 621, 622:
            icon = UIImage(named: "snowy")
        case 800:
            icon = UIImage(named: "day")
        case 801, 802, 803, 804:
            icon = UIImage(named: "cloudy")
        default:
            icon = UIImage(named: "weather")
            break
        }
        
        return icon
    }
}
