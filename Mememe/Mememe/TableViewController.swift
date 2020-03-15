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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        let  cell = tableView.dequeueReusableCell(withIdentifier: "memeList")!
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        return cell
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let  delegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = delegate.memes
        self.tableView!.reloadData()
        print("in viewWillAppear \(delegate.memes.count)")
    }

    @IBAction func showEditor(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(identifier: "editorView") as! ViewController
        controller.hidesBottomBarWhenPushed =  true
        self.navigationController!.pushViewController(controller, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
