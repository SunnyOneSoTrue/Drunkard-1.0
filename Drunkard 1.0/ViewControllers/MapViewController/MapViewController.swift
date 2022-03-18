//
//  MapViewController.swift
//  Drunkard 1.0
//
//  Created by USER on 07.03.22.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth

class MapViewController: UIViewController{
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        
        map.delegate = self
        
        checkLocationServices()
        
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController)!
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    @IBAction func onAdd(_ sender: UIButton) {
    }
    
}



extension MapViewController: MKMapViewDelegate{
    
}

extension MapViewController:  CLLocationManagerDelegate{
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: CLLocationDistance(regionInMeters), longitudinalMeters: CLLocationDistance(regionInMeters))
        map.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }
        else{
            //TODO: show alert to user that you have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //TODO: show an alert letting them know whats up
            break
        case .denied:
            //TODO: Show alert instructing to turn on permissions
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            CenterViewOnUserLocation()
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func CenterViewOnUserLocation (){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: CLLocationDistance(regionInMeters), longitudinalMeters: CLLocationDistance(regionInMeters))
            map.setRegion(region, animated: true)
        }
    }
    
}
