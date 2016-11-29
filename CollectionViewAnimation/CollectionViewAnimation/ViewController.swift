//
//  ViewController.swift
//  CollectionViewAnimation
//
//  Created by Bevis Chen on 2016/11/29.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset.top = 20
        }
    }
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    let photos = ["1", "2", "3", "4", "5"]
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Set UI
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
// MARK:- UICollectionView Delegate and DataSource
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        
        collectionView.bringSubview(toFront: cell)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            
            cell.frame = cell.selectedFrame
            
        }) { (isFinish) in
            
            cell.backBtn.isHidden = false
            collectionView.isScrollEnabled = false
            cell.layer.cornerRadius = 0
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        cell.phptoImageView.image = UIImage(named: photos[indexPath.row])
        cell.backBtnAction = {
            cell.backBtn.isHidden = true
            cell.layer.cornerRadius = 10
            collectionView.isScrollEnabled = true
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
}
