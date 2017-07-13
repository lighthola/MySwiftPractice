//
//  SwipeTabFlowLayout.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/5.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class SwipeTabFlowLayout: UICollectionViewFlowLayout {
    
    var isSetup = false
    var lastSelectedTab = 0
    var getSelectedTab: (()->Int)?
    var attributes: [UICollectionViewLayoutAttributes]?
    
    override func prepare() {
        guard let collectionView = collectionView else {
            fatalError("collectionView not found.")
        }
        
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        let tabsCount = collectionView.numberOfItems(inSection: 0)
        itemSize = CGSize(width: width / (CGFloat(tabsCount) + 1), height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if let attrs = super.layoutAttributesForElements(in: rect) {
            guard let selectedTap = getSelectedTab?() else {
                fatalError("The closure of getSelectedTab not implemented.")
            }
            for attr in attrs {
                if attr.indexPath.row == selectedTap {
                    lastSelectedTab = selectedTap
                    attr.frame.size.width = attr.frame.size.width * 2
                }
                else if attr.indexPath.row > selectedTap {
                    attr.frame.origin.x += attr.frame.size.width
                }
                else {
                    
                }
            }
            return attrs
        }
        return super.layoutAttributesForElements(in: rect)
    }
    
    
}
