//
//  ViewController.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 2/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func navigateToMainTab(_ sender: Any) {
        
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (successful, error) in
            if successful {
                let storyboard = UIStoryboard (name: "Main", bundle: nil)
                let mainTab = storyboard.instantiateViewController(identifier: "MainTabController") as! UITabBarController
                self.navigationController?.setToolbarItems([UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)], animated: true)
                self.navigationController?.pushViewController(mainTab, animated: false)
            } else {
                print("login failed: \(error?.localizedDescription ?? "")")
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
//        performSegue(withIdentifier: "mainTab", sender: sender)
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }

}

