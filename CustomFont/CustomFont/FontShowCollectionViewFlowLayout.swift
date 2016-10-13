//
//  FontShowCollectionViewFlowLayout.swift
//  CustomFont
//
//  Created by Bevis Chen on 2016/10/13.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class FontShowCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        baseInit()
    }
    
    private func baseInit() {
    
        NSLog("Flow Layout Init Execute.")
        
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
