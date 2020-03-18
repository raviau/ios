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
    @IBOutlet var viewYConstraint: NSLayoutConstraint!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0
    ]
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func save(type: UIActivity.ActivityType?, completed:  Bool, items: [Any]?, error:  Error?) {
        if completed {
            let  delegate = UIApplication.shared.delegate as! AppDelegate
            let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
            delegate.memes.append(meme)
        }
//        self.navigationController!.popToRootViewController(animated: true)
        self.navigationController!.popToRootViewController(animated: true)
//        dismiss(animated: true, completion: nil)
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

        enableDisableShareButton()

        topText.delegate = self
        bottomText.delegate = self
        
        
        topText.textAlignment = .center
        topText.defaultTextAttributes = memeTextAttributes
        topText.borderStyle = .none
//        topText.isHidden = true
        topText.text = "TOP"
        
        
        bottomText.textAlignment = .center
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.borderStyle = .none
//        bottomText.isHidden =  true
        bottomText.text = "BOTTOM"
        
        
        
        // Do any additional setup after loading the view.
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    fileprivate func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate  = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        presentImagePicker(sourceType: .savedPhotosAlbum)
    }
    @IBAction func pickFromCamera(_ sender: Any) {
        presentImagePicker(sourceType: .camera)

    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = save
//        self.navigationController!.popoverPresentationController(controller, animated: true)

        present(controller, animated: true, completion: nil)
        
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
        if bottomText.isEditing {
            viewYConstraint.constant -= getKeyboardHeight(notification)
        }

    }

    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isEditing {
            viewYConstraint.constant += getKeyboardHeight(notification)
        }

//        view.frame.origin.y += getKeyboardHeight(notification)
    }

    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        print(userInfo!)
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            topText.isHidden = false
            bottomText.isHidden =  false
        } else {
            print("unable to load image")
        }
        
        enableDisableShareButton()
        dismiss(animated: true, completion: nil)
    }
    
    func enableDisableShareButton() {
        if let uiItems = navigationItem.rightBarButtonItems {
            for item in uiItems  {
                if item.title == "Share" {
                    item.isEnabled = (imageView.image != nil)
                }
            }
        }
    }
    
    func generateMemedImage() -> UIImage {

        toolBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        toolBar.isHidden = false

        return memedImage
    }


    
}

