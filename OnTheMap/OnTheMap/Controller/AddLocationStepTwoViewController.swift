//
//  AddLocationStepTwoViewController.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 20/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationStepTwoViewController: UIViewController {

    var address: String!
    var media: String!
    var coordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let address = address {
            CLGeocoder().geocodeAddressString(address, completionHandler: {
                  (placemarks, error) -> Void in

                  if let placemark = placemarks?[0] {
                    if let coorrdinate = placemark.location?.coordinate {
                        self.coordinate = coorrdinate
                        let selectedAddress = MKMapRect(x: coorrdinate.longitude, y: coorrdinate.latitude, width: 100, height: 100)
                        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
//                        self.mapView.setVisibleMapRect(selectedAddress, animated: true)
                        self.mapView.setCenter(coorrdinate, animated: true)
                    }
                  } else {
                    self.showFailure(message: "Could not locate address")
                }
              })
        } else {
            self.showFailure(message: "Please provide address.")
        }
    }
    
    @IBAction func addLocation() -> Void {
        if let coordinate = coordinate {
            UdacityClient.addLocation(firstName: "Kim Jong", lastName: "Un", mapString: address, mediaURL: media, latitude: coordinate.latitude, longitude: coordinate.longitude) { (success, error) in
                if success {
                    let storyboard = UIStoryboard (name: "Main", bundle: nil)
                    let mainTab = storyboard.instantiateViewController(identifier: "MainTabController") as! UITabBarController
                    self.navigationController?.setToolbarItems([UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)], animated: true)
                    self.navigationController?.pushViewController(mainTab, animated: false)

                }
            }

        }
    }
    
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Address Exception", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

}
