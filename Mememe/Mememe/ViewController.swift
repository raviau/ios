//
//  ViewController.swift
//  Mememe
//
//  Created by Santhana Ravi on 4/3/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate{

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 7.0
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uiItems = toolBar.items {
            for item in uiItems  {
                if item.title == "Camera" {
                    item.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
                }
            }
        }
        
        topText.delegate = self
        bottomText.delegate = self
        
        
        topText.textAlignment = .center
        topText.defaultTextAttributes = memeTextAttributes
        topText.borderStyle = .none
        topText.text = "TOP"
        
        
        bottomText.textAlignment = .center
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.borderStyle = .none
        bottomText.text = "BOTTOM"
        
        
        
        // Do any additional setup after loading the view.
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("textField: \(textField.text ?? "noValue")")
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func pickImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate  = self
        imagePickerController.sourceType = .savedPhotosAlbum
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func pickFromCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate  = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)

    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {

        print(notification.object)
        view.frame.origin.y -= getKeyboardHeight(notification)
    }

    @objc func keyboardWillHide(_ notification:Notification) {

        
        view.frame.origin.y += getKeyboardHeight(notification)
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
        } else {
            print("unable to load image")
        }
        
        dismiss(animated: true, completion: nil)
    }

    
}

