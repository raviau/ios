//
//  AddLocationStepOneViewController.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 20/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit

class AddLocationStepOneViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var address: UITextField!
    @IBOutlet var media: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func geoCode() -> Void {
        let controller = self.storyboard!.instantiateViewController(identifier: "geoCodeView") as! AddLocationStepTwoViewController
        controller.address = address.text ?? ""
        controller.media = media.text ?? ""
            
        self.navigationController!.pushViewController(controller, animated: false)
    }

}
