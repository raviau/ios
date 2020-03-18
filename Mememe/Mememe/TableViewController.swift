//
//  TableViewController.swift
//  Mememe
//
//  Created by Santhana Ravi on 15/3/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var memes: [Meme] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showEditor))

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        let  cell = tableView.dequeueReusableCell(withIdentifier: "memeList")!
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let memeDetailViewController = self.storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewController.meme = meme
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let  delegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = delegate.memes
        self.tableView!.reloadData()
    }

    @objc func showEditor(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(identifier: "editorView") as! ViewController
        controller.hidesBottomBarWhenPushed =  true
        self.navigationController!.pushViewController(controller, animated: false)
    }

}
