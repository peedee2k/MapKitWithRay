//
//  ViewController.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 5/12/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
   
    @IBOutlet weak var pinImage: UIImageView!
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var geoCoder: CLGeocoder?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        myMap.delegate = self
        setUpLocation()
        pinConstrain()
        goBackToMap()
    }
    
    func goBackToMap() {
             //   navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav-address")
          //     navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav-address")
        let backImage = UIImage(named: "nav-address")
        navigationItem.backBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: nil, action: #selector(backButton))
        
    }
    
    @objc func backButton() {
        
    }
    
    
    func pinConstrain() {
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        pinImage.centerXAnchor.constraint(equalTo: myMap.centerXAnchor ).isActive = true
        pinImage.bottomAnchor.constraint(equalTo: myMap.centerYAnchor).isActive = true
        pinImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        pinImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setUpLocation() {
        // Current location is sears tower Chicago :)
        currentLocation = CLLocation(latitude: 41.878876, longitude: -87.635915)
        
        let regionRedius:CLLocationDistance = 600.0
        let region = MKCoordinateRegion.init(center: (currentLocation?.coordinate)!, latitudinalMeters: regionRedius, longitudinalMeters: regionRedius)
         myMap.showsUserLocation = true
        myMap.setRegion(region, animated: true)
        
        showAddressLabel(address: currentLocation!)
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
    }
    
    func showAddressLabel(address: CLLocation) {
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        
        geoCoder?.reverseGeocodeLocation(address, completionHandler: { [weak self](placemarks, error) in
            let placeMark = placemarks?.first
            let streetNum = placeMark?.subThoroughfare
            let street = placeMark?.thoroughfare
            let city = placeMark?.locality
            let state = placeMark?.administrativeArea
            var address = ""
            if streetNum == nil || street == nil {
                address = "\(city!). \(state!)"
                
            } else if streetNum == nil{
                address = "\(street!) \(city!). \(state!)"
            } else {
                address = "\(streetNum!) \(street!) \(city!). \(state!)"
            }
                self?.addressLabel.text = address
            })
        }
    }

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // I am not sure which code I should write here
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError {
            case CLError.locationUnknown:
                print("Location unknown")
            case CLError.denied:
                print("Access denied")
            default:
                print("Location Error")
            }
        } else {
            print("Error:",error.localizedDescription)
        }
            }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
                }
            }
        }

extension ViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        currentLocation = CLLocation(latitude: myMap.centerCoordinate.latitude, longitude: myMap.centerCoordinate.longitude)
       
        showAddressLabel(address: currentLocation!)
            }
        }
