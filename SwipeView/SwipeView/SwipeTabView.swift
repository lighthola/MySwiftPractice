//
//  SwipeTab.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/5.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class SwipeTabView: UIView {
    
    @IBOutlet var  collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: SwipeTabFlowLayout!
    
    var tabs = [SwipeTabItemData]() {
        didSet {
            
        }
    }
    var selectedTab = 0
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        baseInit()
    }
    
    func baseInit() {
        if let view = Bundle.main.loadNibNamed(String(describing: SwipeTabView.self), owner: self, options: nil)?.last as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        collectionView.register(UINib.init(nibName: String(describing: SwipeTabItem.self), bundle: nil), forCellWithReuseIdentifier: "cell")
        
        backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2980392157, blue: 0.3764705882, alpha: 1)
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2980392157, blue: 0.3764705882, alpha: 1)
        
        flowLayout.getSelectedTab = getSelectedTab
        
    }
    
    func getSelectedTab() -> Int {
        return selectedTab
    }
}

extension SwipeTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SwipeTabItem
        cell.imageView.image = tabs[indexPath.item].image
        cell.titleLabel.text = tabs[indexPath.item].title
        return cell
    }
}

extension SwipeTabView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selectedTab: \(indexPath.item)")
        selectedTab = indexPath.item
        
        collectionView.performBatchUpdates({
            let layout = collectionView.collectionViewLayout as! SwipeTabFlowLayout
            layout.isSetup = true
            //collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.layoutIfNeeded()
        }, completion: nil)
    }
}

