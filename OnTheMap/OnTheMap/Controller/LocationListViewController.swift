//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 20/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController {

    var locations = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(showEditor))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(logout))

        UdacityClient.getStudentLocations { (studentLocations, error) in
            if let studentLocations = studentLocations {
                DispatchQueue.main.async {
                    for studentLocation in studentLocations.results {
                        self.locations.append(studentLocation.dictionary)
                    }
                    self.tableView.reloadData()
                }
                
                
            }
        }


    }
    

    @objc func showEditor(_ sender: Any) {
        print("showinng editor")
        let controller = self.storyboard!.instantiateViewController(identifier: "addLocation") as! AddLocationStepOneViewController
        controller.hidesBottomBarWhenPushed =  true
        self.navigationController!.pushViewController(controller, animated: false)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(self.locations.count)")
        return self.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let student = self.locations[(indexPath as NSIndexPath).row]
        let firstName = student["firstName"] as! String
        let lastName = student["lastName"] as! String

        cell.textLabel?.text = firstName +  " " + lastName
        cell.imageView?.image = UIImage(systemName: "pin.fill")
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let student = self.locations[(indexPath as NSIndexPath).row]
        let url = student["mediaURL"] as! String

            app.open(URL(string: url)!, options: [:], completionHandler: nil)
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
