//
//  MasonryLayout.swift
//  MasonryLayout
//
//  Created by Bevis Chen on 2017/3/16.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

protocol MasonryLayoutDelegate
{
    func masonryLayout(_ masonryLaout: MasonryLayout, cellHeightForItemAt indexPath: IndexPath) -> CGFloat
}

class MasonryLayout: UICollectionViewFlowLayout
{
    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    var delegate: MasonryLayoutDelegate?
    var maxColumns = 1
    var itemWidth: CGFloat = 0
    fileprivate var attributesArray: [UICollectionViewLayoutAttributes]?
    fileprivate var headerAttributes: UICollectionViewLayoutAttributes?
    fileprivate var footerAttributes: UICollectionViewLayoutAttributes?
    fileprivate var xOfColumns:[CGFloat]?
    fileprivate var maxYOfColumns: [CGFloat]?
    
    // MARK:- Constant
    
    
    // MARK:-
    
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else {
            return;
        }
        
        minimumLineSpacing = 10.0
        minimumInteritemSpacing = 10.0
        
        sectionInset.top = 10
        sectionInset.left = 10
        sectionInset.bottom = 10
        sectionInset.right = 10
        
        headerReferenceSize = CGSize(width: collectionView.bounds.size.width, height: 100)
        footerReferenceSize = CGSize(width: collectionView.bounds.size.width, height: 50)
        sectionHeadersPinToVisibleBounds = true
        sectionFootersPinToVisibleBounds = true
        
        
        let screenWidth = UIScreen.main.bounds.size.width
        itemWidth = (screenWidth - (minimumLineSpacing * CGFloat(maxColumns - 1) + sectionInset.left + sectionInset.right)) / CGFloat(maxColumns)
        
        // default item size
        let height = 60.0
        itemSize = CGSize(width: Double(itemWidth), height: height)
        
        // default height of columns
        maxYOfColumns = [CGFloat](repeating: sectionInset.top, count: maxColumns)
        // To calculate x position of columns
        xOfColumns = [self.sectionInset.left]
        if maxColumns > 1 {
            for i in 1 ... maxColumns {
                let xPositionOfColumns = sectionInset.left + CGFloat(i) * (itemWidth + minimumInteritemSpacing)
                xOfColumns!.append(xPositionOfColumns)
            }
        }
        
        // Getting postion of items
        attributesArray = [UICollectionViewLayoutAttributes]()
        
        for i in 0 ... collectionView.numberOfItems(inSection: 0) - 1
        {
            let attributes = self.layoutAttributesForItem(at: IndexPath(item: i, section: 0))
            attributesArray!.append(attributes!)
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as! UICollectionViewLayoutAttributes?
        if elementKind == UICollectionElementKindSectionHeader
        {
            attributes?.frame = CGRect(origin: CGPoint(x: 0, y: -headerReferenceSize.height), size: headerReferenceSize)
        }
        else if elementKind == UICollectionElementKindSectionFooter
        {
            attributes?.frame = CGRect(origin: CGPoint(x: 0, y: maxYOfColumns!.sorted().last!), size: footerReferenceSize)
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes?
        
        // System will call this method when collection view insert items then cause the maxYOfColumns wrong.
        guard attributesArray!.count != collectionView?.numberOfItems(inSection: 0) else {
            return attributes
        }
        
        guard let delegate = self.delegate else {
            return attributes
        }
        
        let minHeight = maxYOfColumns!.sorted().first!
        let minHeightColumns = maxYOfColumns!.index(of: minHeight)!
        let itemHeight = delegate.masonryLayout(self, cellHeightForItemAt: indexPath)
        maxYOfColumns![minHeightColumns] += itemHeight + minimumLineSpacing
        
        attributes?.frame = CGRect(x: xOfColumns![minHeightColumns], y: minHeight, width: itemWidth, height: itemHeight)
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        super.layoutAttributesForElements(in: rect)
        
        if headerAttributes == nil {
            headerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0))
        }

        if footerAttributes == nil {
            footerAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: IndexPath(item: 0, section: 0))
        }
        
        // recalculating footer's Y every time
        footerAttributes?.frame.origin.y = maxYOfColumns!.sorted().last!
        
        var newAttributesArray = [UICollectionViewLayoutAttributes]()
        newAttributesArray.append(contentsOf: attributesArray!)
        newAttributesArray.append(headerAttributes!)
        newAttributesArray.append(footerAttributes!)
        //print("!!!")
        return newAttributesArray
    }
    
    override var collectionViewContentSize: CGSize
    {
        // return the fianl height of collectionview
        let height = footerAttributes != nil ? maxYOfColumns!.sorted().last! + footerAttributes!.frame.height : maxYOfColumns!.sorted().last!
        return CGSize(width: 0, height: height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        // Invalidating Layout when bounds be changed.
        let oldBounds = self.collectionView?.bounds
        if oldBounds?.width != newBounds.width {
            return false
        }
        return true
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        
    }
    
    // Controlling ANIMATION for inserting item
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attributes?.frame.origin.y = maxYOfColumns!.sorted().last! + 10
        return attributes
    }
    
    // Controlling ANIMATION for deleting item
//    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
//        
//        return attributes
//    }
}
