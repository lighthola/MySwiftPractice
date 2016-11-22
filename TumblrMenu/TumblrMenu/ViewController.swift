//
//  ViewController.swift
//  TumblrMenu
//
//  Created by Bevis Chen on 2016/11/21.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    let posts:[(author: String, authorPhoto: String, post: String)] =
        [("Hugo", "hugo", "1"),
         ("Mengto", "mengto", "2")]
    
    
    // MARK:-

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK:- Action methods
    @IBAction func newPostBtnPressed(_ sender: Any) {
        
    }
    
    // MARK:-  Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func exitToHere(_ sender: UIStoryboardSegue) {
        
        
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK:- UICollectionView Data Source
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TumblrPostCollectionViewCell
        
        cell.authorLabel.text = posts[indexPath.row].author
        cell.authorImageView.image = UIImage(named: posts[indexPath.row].authorPhoto)
        cell.postImageView.image = UIImage(named: posts[indexPath.row].post)
        
        return cell
    }
}

// MARK:- UICollectionView Delegate Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let postWidth = collectionView.bounds.width
        let imageWidth = UIImage(named: posts[indexPath.row].post)!.size.width
        
        // If image width less than cell width, set to default size.
        guard imageWidth >= postWidth else {
            return CGSize(width: postWidth, height: 220)
        }
        
        // Dynamic height for cell
        let ratio = postWidth / imageWidth
        let postHeight = ratio * UIImage(named: posts[indexPath.row].post)!.size.height + 64
        
        return CGSize(width: postWidth, height: postHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // Set first section top to zero.
        let top: CGFloat = section == 0 ? 0 : 30
        
        return UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }
}
