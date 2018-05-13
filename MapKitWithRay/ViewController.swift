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
        
        let regionRedius:CLLocationDistance = 100.0
        let region = MKCoordinateRegionMakeWithDistance((currentLocation?.coordinate)!, regionRedius, regionRedius)
         myMap.showsUserLocation = true
        myMap.setRegion(region, animated: true)
        
        showAddressLabel(address: currentLocation!)
        
        // Annotation
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
      
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
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
