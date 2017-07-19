//
//  StartViewController.swift
//  SimpleTableView
//
//  Created by apple on 18/7/2017.
//  Copyright © 2017 greatwall. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StartViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .standard
            mapView.showsUserLocation = true
        }
    }

    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.isEnabled = false
        }
    }
    
    lazy var geocode: CLGeocoder = {
        return CLGeocoder()
    }()
    
    private var forPassCoordinate = CLLocationCoordinate2D()

    private let locationManager = CLLocationManager()

    @IBAction func chooseALocation(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = Constants.minPressDuration
        sender.allowableMovement = Constants.longestMovement
        
        if sender.state == .ended {
            return
        }
        
        let touchPoint = sender.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        forPassCoordinate = touchMapCoordinate
        
        addAnnotation(with: touchMapCoordinate)
        covertToAddress(from: touchMapCoordinate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Choose an Address"
        confirmButton.setTitleColor(UIColor.lightText, for: .normal)
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        let userLocationCoordinate = getUserLocation(check: authStatus)
        
        if userLocationCoordinate != nil {
            covertToAddress(from: userLocationCoordinate!)
            let region = MKCoordinateRegionMakeWithDistance(userLocationCoordinate!, Constants.latitudinalMeterScale, Constants.longitudinalMeterScale)
            mapView.setRegion(region, animated: true)
            forPassCoordinate = userLocationCoordinate!
        }
    }
    
    private func getUserLocation(check authStatus: CLAuthorizationStatus) -> CLLocationCoordinate2D? {
        if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            let latitude = (locationManager.location?.coordinate.latitude)!
            let longitude = (locationManager.location?.coordinate.longitude)!
            
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        return nil
    }

    private struct Constants {
        static let minPressDuration = 0.5
        static let longestMovement = CGFloat(10.0)
        static let latitudinalMeterScale: CLLocationDegrees = 1000
        static let longitudinalMeterScale: CLLocationDegrees = 1000
    }
}

extension UIViewController {
    var content: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController ?? self
        } else {
            return self
        }
    }
}





