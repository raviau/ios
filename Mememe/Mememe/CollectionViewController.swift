//
//  CollectionViewController.swift
//  Mememe
//
//  Created by Santhana Ravi on 15/3/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    @IBOutlet var flowLayout:  UICollectionViewFlowLayout!
    
    var memes: [Meme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(
        title: "Add",
        style: .plain,
        target: self,
        action: #selector(showEditor))
        
        let space:CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let memeDetailViewController = self.storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewController.meme = meme
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)

    }

    @objc func showEditor(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(identifier: "editorView") as! ViewController
        controller.hidesBottomBarWhenPushed =  true
        self.navigationController!.pushViewController(controller, animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("in numberOfItemsInSection: \(memes.count)")
        return memes.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let meme = memes[indexPath.row]
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as!  CollectionViewCell
//        cell.backgroundColor = UIColor.red
//        cell.contentView.backgroundColor = UIColor.red
        cell.imageView?.image = meme.memedImage
        
//        print(cell.label.text)
//        cell.contentView.backgroundColor = UIColor(named: "red")
//        cell.contentView.
        
        print("cell: \(cell.debugDescription)")
        print("cell.contentView: \(cell.contentView.debugDescription)")
        print("cell.imageView: \(cell.imageView.debugDescription)")

        return cell

    }
    override func viewWillAppear(_ animated: Bool) {
        let  delegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = delegate.memes
        self.collectionView!.reloadData()
    }




}
