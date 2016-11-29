//
//  CustomCollectionViewFlowLayout.swift
//  CollectionViewAnimation
//
//  Created by Bevis Chen on 2016/11/29.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        baseInit()
    }
    
    // support layout update when orientation
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        // layout update when orient.
        if collectionView?.bounds.size.width != newBounds.size.width {
            
            baseInit()
            
        }
        return true
    }
    
    private func baseInit() {
        
        NSLog("Flow Layout Init Execute.")
        
        let margin = 10.0
        minimumLineSpacing = 10.0
        minimumInteritemSpacing = 10.0
        
        let screenWidth = Double(UIScreen.main.bounds.size.width)
        let maxCol = Double(1)
        let width = (screenWidth - margin * (maxCol + 1)) / maxCol
        let height = 250.0
        itemSize = CGSize(width: width, height: height)
    }

}
