//
//  MyCollectionViewFlowLayout.swift
//  PullToRefresh
//
//  Created by Bevis Chen on 2016/10/20.
//  Copyright © 2016年 Allen. All rights reserved.
//

import UIKit

class MyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        baseInit()
    }
    
    // support layout update when orientation
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
//        print("Should Invalidate Layout for Bounds Change")
        
        baseInit()
        return true
    }
    
    private func baseInit() {
        
//        print("Flow Layout Init Execute.")
        
        let margin = 1.0
        minimumLineSpacing = 10.0
        minimumInteritemSpacing = 10.0
        
        let screenWidth = Double(UIScreen.main.bounds.size.width)
        let maxCol = Double(1)
        let width = (screenWidth - margin * (maxCol + 1)) / maxCol
        let height = 60.0
        itemSize = CGSize(width: width, height: height)
    }
}
