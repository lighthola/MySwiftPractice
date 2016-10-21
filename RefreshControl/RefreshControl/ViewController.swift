//
//  ViewController.swift
//  RefreshControl
//
//  Created by Bevis Chen on 2016/10/20.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    // MARK:- IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK:- Variable
    var texts = ["👸👸👸👸👸", "🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆"]
    
    // MARK:- Constant
    let moreText = ["🏃🏃🏃🏃🏃", "💩💩💩💩💩"]
    let refreshControl = UIRefreshControl()
    
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refresh control only supports Vertical.
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    // MARK:- Set UI
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK:- Private Methods
    @objc fileprivate func refresh() {
        
        texts.append(contentsOf: moreText)
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK:- UIScrollViewDelegate Methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
//        print("--\n Frame: \(scrollView.frame)\n Bounds: \(scrollView.bounds)\n--")
        if !refreshControl.isRefreshing && scrollView.bounds.origin.y < 0 {
            
            refreshControl.attributedTitle = NSAttributedString(string: "\(Date())", attributes: [NSForegroundColorAttributeName: UIColor.white])
        }
    }
    
    // MARK:- UICollectionViewDelegate Methods
    // MARK:- UICollectionViewDataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellID = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyCollectionViewCell
        cell.textLabel.text = texts[indexPath.row]
        
        return cell
    }

    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

