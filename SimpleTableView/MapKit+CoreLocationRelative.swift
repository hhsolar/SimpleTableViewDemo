//
//  MapKit+CoreLocationRelative.swift
//  DoorDashThird
//
//  Created by apple on 12/7/2017.
//  Copyright © 2017 greatwall. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension StartViewController {
    
    // MARK: Annotation
    internal func addAnnotation(with coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        //        annotation.title =
        //        annotation.subtitle =
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        mapView.addAnnotation(annotation)
    }
    
    // MARK: Convert coordinate to address
    internal func covertToAddress(from coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocode.reverseGeocodeLocation(location, completionHandler: { [weak weakself = self]
            (placemarks: [CLPlacemark]?, error: Error?) in
            if error != nil {
                print("Error happened when convert to address: \(String(describing: error))")
                return
            }
            
            let placemark = placemarks?.first
            weakself?.addressLabel.text = self.stringFromPlacemark(placemark!)
            weakself?.confirmButton.isEnabled = true
            weakself?.confirmButton.setTitleColor(UIColor.white, for: .normal)
        })
    }
    
    
    // MARK: MKMapViewDelegate
    
    

    private func stringFromPlacemark(_ placemark: CLPlacemark) -> String {
        var text = ""
        if let s = placemark.subThoroughfare {
            text += s + " "
        }
        if let s = placemark.thoroughfare {
            text += s + ", "
        }
        if let s = placemark.locality {
            text += s + ", "
        }
        if let s = placemark.administrativeArea {
            text += s + " "
        }
        if let s = placemark.postalCode {
            text += s
        }
        return text
    }
    
}
