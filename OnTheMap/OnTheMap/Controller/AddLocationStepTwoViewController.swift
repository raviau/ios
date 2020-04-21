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

    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    fileprivate func initializeActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style =  UIActivityIndicatorView.Style.medium
        self.view.addSubview(self.activityIndicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if let address = address {


            initializeActivityIndicator()
            self.activityIndicator.startAnimating()

            CLGeocoder().geocodeAddressString(address, completionHandler: {
                  (placemarks, error) -> Void in

                  if let placemark = placemarks?[0] {
                    if let coorrdinate = placemark.location?.coordinate {
                        self.coordinate = coorrdinate
                        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                        self.mapView.setCenter(coorrdinate, animated: true)
                    }
                    self.activityIndicator.stopAnimating()
                  } else {
                    self.activityIndicator.stopAnimating()
                    self.showFailure(message: "Could not locate address")
                }
              })
            self.activityIndicator.stopAnimating()
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
