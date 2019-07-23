//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Tiago Pestana on 23/07/2019.
//  Copyright © 2019 Tiago Pestana. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var adressLbl: UILabel!
    @IBOutlet weak var pinImg: UIImageView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var previousLocation: CLLocation?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        pinImg.image = UIImage(named: "pin_icon")?.withRenderingMode(.alwaysTemplate)
        pinImg.tintColor = .red
        
        checkLocationServices()
    }
    
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus()
        {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            requestLocationPermissionThroughSettings()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func startTrackingUserLocation()
    {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        previousLocation = getCenterLocation(for: mapView)
        locationManager.startUpdatingLocation()
    }
    
    func requestLocationPermissionThroughSettings()
    {
        let alert = UIAlertController(title: "Location Permissions", message: "This app requires access to your location to function properly. You can set this up on the device's preferences by tapping below.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default)
        { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl)
            {
                UIApplication.shared.open(settingsUrl)
                { success in
                    print("Settings opened: \(success)")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            setupLocationManager()
            checkLocationAuthorization()
        }
        else
        {
            // prompt user to turn on location services
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation
    {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension ViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}

extension ViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let _ = self.previousLocation else { return }
        guard center.distance(from: previousLocation!) > 50 else { return }
        previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center)
        { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let _ = error { return }
            guard let placemark = placemarks?.first else { return }
            
            let streetName = placemark.thoroughfare ?? ""
            let subLocality = placemark.subLocality ?? ""
            DispatchQueue.main.async
            {
                self.adressLbl.text = "\(streetName), \(subLocality)"
            }
        }
    }
}
