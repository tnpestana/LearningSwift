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
    @IBOutlet weak var directionsBtn: UIButton!
    
    enum OperationMode: String
    {
        case SelectDestination = "Select Destination"
        case ShowDirections = "Get Directions"
    }
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var previousLocation: CLLocation?
    var showingDirections: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        pinImg.image = UIImage(named: "pin_icon")?.withRenderingMode(.alwaysTemplate)
        pinImg.tintColor = .red
        adressLbl.text = "Choose location:"
        
        checkLocationServices()
        setupView()
    }
    
    @IBAction func directionsBtnTapped(_ sender: Any)
    {
        showingDirections = !showingDirections
        if showingDirections
        {
            pinMarker()
            getDirections()
        }
        setupView()
    }
    
    func setupView()
    {
        let btnTitle = showingDirections ? OperationMode.SelectDestination.rawValue : OperationMode.ShowDirections.rawValue
        directionsBtn.setTitle(btnTitle, for: .normal)
        if showingDirections
        {
            pinImg.isHidden = true
        }
        else
        {
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
            pinImg.isHidden = false
        }
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
            let alert = UIAlertController(
                title: "Location Services",
                message: "This app requires access to your device's location services. You can turn them on via the device's preferences.",
                preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        if let location = previousLocation { updateAdressLbl(location: location) }
        locationManager.startUpdatingLocation()
    }
    
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation
    {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func requestLocationPermissionThroughSettings()
    {
        let alert = UIAlertController(
            title: "Location Permissions",
            message: "This app requires access to your location to function properly. You can set this up on the device's preferences by tapping below.",
            preferredStyle: .alert)
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
    
    func getDirections()
    {
        guard let location = locationManager.location else { return }
        let request = createDirectionsRequest(from: location.coordinate)
        let directions = MKDirections(request: request)
        //mapView.removeOverlays(mapView.overlays) // clean map from older overlay
        directions.calculate
        { [unowned self] (response, error) in
            // insert error handling here
            guard let response = response else { return }
            for route in response.routes
            {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect.insetBy(dx: -200, dy: -200), animated: true)
            }
        }
    }
    
    func pinMarker()
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = getCenterLocation(for: mapView).coordinate
        mapView.addAnnotation(annotation)
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request
    {
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        return request
    }
    
    func updateAdressLbl(location: CLLocation)
    {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location)
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
        if !showingDirections
        {
            let center = getCenterLocation(for: mapView)
            guard let _ = self.previousLocation else { return }
            guard center.distance(from: previousLocation!) > 50 else { return }
            previousLocation = center
            updateAdressLbl(location: center)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.alpha = CGFloat(50)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
}
