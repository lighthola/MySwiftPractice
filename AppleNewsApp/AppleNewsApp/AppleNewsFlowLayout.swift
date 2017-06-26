//
//  ApppleNewFlowLayout.swift
//  AppleNewsApp
//
//  Created by Bevis Chen on 2017/6/26.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

protocol AppleNewsFlowLayoutDelegate: class
{
    func AppleNewsFlowLayout(_ AppleNewsFlowLayout: AppleNewsFlowLayout, cellTypeForItemAt indexPath: IndexPath) -> NewsCellType
}

class AppleNewsFlowLayout: UICollectionViewFlowLayout {
    
    var maxY: CGFloat = 0.0
    var isVSetOnce = false
    weak var delegate: AppleNewsFlowLayoutDelegate?
    var attributesArray: [UICollectionViewLayoutAttributes]?

    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = 10
        minimumInteritemSpacing = 16
        
        sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
     
        guard let newsType: NewsCellType = delegate?.AppleNewsFlowLayout(self, cellTypeForItemAt: indexPath) else {
            fatalError("AppleNewsFlowLayoutDelegate method is required.")
        }
        
        let screenWidth = UIScreen.main.bounds.width
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        var x = sectionInset.left
        maxY = maxY + minimumLineSpacing
        switch newsType {
            
        case .big:
            let width = screenWidth - sectionInset.left - sectionInset.right
            attributes.frame = CGRect(x: x, y: maxY, width: width, height: width * 1.2)
            maxY += width * 1.2
            
        case .horizontal:
            let width = screenWidth - sectionInset.left - sectionInset.right
            attributes.frame = CGRect(x: x, y: maxY, width: width, height: 150)
            maxY += 150
            
        case .vertical:
            let width = (screenWidth - minimumInteritemSpacing - sectionInset.left - sectionInset.right) / 2
            x = isVSetOnce ? x + width + minimumInteritemSpacing : x
            maxY = isVSetOnce ? maxY-10 : maxY
            attributes.frame = CGRect(x: x, y: maxY, width: width, height: screenWidth * 0.8)
            if isVSetOnce {
                maxY += screenWidth * 0.8
            }
            isVSetOnce = !isVSetOnce
        }
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: maxY)
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if attributesArray == nil {
            attributesArray = [UICollectionViewLayoutAttributes]()
            for i in 0 ... collectionView!.numberOfItems(inSection: 0) - 1
            {
                let attributes = self.layoutAttributesForItem(at: IndexPath(item: i, section: 0))
                attributesArray!.append(attributes!)
            }
        }
        return attributesArray
    }
}
