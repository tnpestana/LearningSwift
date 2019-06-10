//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tiago Pestana on 08/06/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController
{
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    
    let API_KEY = "8c3536992559ac53a6323e6f7efcc2cc"
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    
    let LOCATION_UNAVAILABLE = "Location Unavailable"
    let CONNECTION_ISSUES = "Connection Issues"
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getWeatherData(url: String, parameters: [String: String])
    {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON
            { (response) in
                if response.result.isSuccess
                {
                    print("success")
                    let weatherJSON: JSON = JSON(response.result.value!)
                    
                    print(weatherJSON)
                }
                else
                {
                    print("error: \(String(describing: response.result.error))")
                    self.lblLocation.text = self.CONNECTION_ISSUES
                }
            }
    }
}

extension MainViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0
        {
            locationManager.stopUpdatingLocation()
        }
        
        let latitude: String = String(location.coordinate.latitude)
        let longitude: String = String(location.coordinate.longitude)
        
        let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : API_KEY]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
        lblLocation.text = LOCATION_UNAVAILABLE
    }
}
