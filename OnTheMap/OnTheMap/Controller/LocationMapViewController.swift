//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 17/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var locations = [[String: Any]] ()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(showEditor))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(logout))

        UdacityClient.getStudentLocations { (studentLocations, error) in
            if let studentLocations = studentLocations {
                DispatchQueue.main.async {
                    for studentLocation in studentLocations.results {
                        locations.append(studentLocation.dictionary)
                    }

                    // We will create an MKPointAnnotation for each dictionary in "locations". The
                    // point annotations will be stored in this array, and then provided to the map view.
                    var annotations = [MKPointAnnotation]()
                    
                    // The "locations" array is loaded with the sample data below. We are using the dictionaries
                    // to create map annotations. This would be more stylish if the dictionaries were being
                    // used to create custom structs. Perhaps StudentLocation structs.
                    
                    for dictionary in locations {
                        
                        // Notice that the float values are being used to create CLLocationDegree values.
                        // This is a version of the Double type.
                        let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                        let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                        
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let first = dictionary["firstName"] as! String
                        let last = dictionary["lastName"] as! String
                        let mediaURL = dictionary["mediaURL"] as! String
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        annotations.append(annotation)
                    }
                    
                    // When the array is complete, we add the annotations to the map.
                    self.mapView.addAnnotations(annotations)
                }
            } else {
                self.showFailure(message: "Unable to get student locations")
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Location list Exception", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }


    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }

    @objc func showEditor(_ sender: Any) {
        print("showinng editor")
        let controller = self.storyboard!.instantiateViewController(identifier: "addLocation") as! AddLocationStepOneViewController
        controller.hidesBottomBarWhenPushed =  true
        self.navigationController!.pushViewController(controller, animated: false)
    }

    @objc func logout(_ sender: Any) {
        print("showinng editor")
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
    }

}
