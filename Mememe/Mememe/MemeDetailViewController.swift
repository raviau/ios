//
//  MemeDetailViewController.swift
//  Mememe
//
//  Created by Santhana Ravi on 18/3/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView?.image =  meme.memedImage
    }
    
}
