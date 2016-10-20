//
//  ViewController.swift
//  FaceDetection
//
//  Created by Bevis Chen on 2016/10/19.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    let images = ["1", "2", "3", "4", "5"]
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK:- Private Methods
    
    // MARK:- UICollectionViewDelegate Methods
    // MARK:- UICollectionViewDataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellID = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

