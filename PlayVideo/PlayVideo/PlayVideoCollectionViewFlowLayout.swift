//
//  PlayVideoCollectionViewFlowLayout.swift
//  PlayVideo
//
//  Created by Bevis Chen on 2016/10/14.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class PlayVideoCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("--\n PlayVideoCollectionViewFlowLayout Init Coder\n--")
        
        baseInit()
    }

    private func baseInit() {
        
        let margin = 0.0
        minimumLineSpacing = 1
        minimumInteritemSpacing = 0.0
        
        let screenWidth = Double(UIScreen.main.bounds.size.width)
        let maxCol = Double(1)
        let width = (screenWidth - margin * (maxCol + 1)) / maxCol
        let height = 220.0
        itemSize = CGSize(width: width, height: height)
    }
    
}
