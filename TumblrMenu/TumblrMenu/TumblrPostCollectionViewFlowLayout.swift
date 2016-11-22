//
//  TumblrPostCollectionViewFlowLayout.swift
//  TumblrMenu
//
//  Created by Bevis Chen on 2016/11/21.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class TumblrPostCollectionViewFlowLayout: UICollectionViewFlowLayout {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        baseInit()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        // layout update when orient.
        if collectionView?.bounds.size.width != newBounds.size.width {
            
            baseInit()
            
        }

        return true
    }
    
    private func baseInit() {
        
        NSLog("Flow Layout Init Execute.")
        
        let margin = 0.0
        minimumLineSpacing = 30.0
        minimumInteritemSpacing = 30.0
        
        let screenWidth = Double(UIScreen.main.bounds.size.width)
        let maxCol = Double(1)
        let width = (screenWidth - margin * (maxCol + 1)) / maxCol
        
        let height = 220.0
        itemSize = CGSize(width: width, height: height)
        
        sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
}
