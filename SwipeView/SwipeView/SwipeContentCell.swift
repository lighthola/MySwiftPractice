//
//  SwipeContentCell.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/12.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class SwipeContentCell: UICollectionViewCell {
    
    var isShowLeftShadow = false {
        didSet {
            leftShadow.removeFromSuperlayer()
            contentView.subviews.first?.layer.insertSublayer(leftShadow, at: 0)
            leftShadow.isHidden = !isShowLeftShadow
        }
    }
    var isShowRightShadow = false
    {
        didSet {
            rightShadow.removeFromSuperlayer()
            contentView.subviews.first?.layer.insertSublayer(rightShadow, at: 0)
            rightShadow.isHidden = !isShowRightShadow
        }
    }
    var isShowLeftOutsideShadow = false {
        didSet {
            let opacity: Float = isShowLeftOutsideShadow ? 0.5 : 0
            setOutsideShadow(offset: -5.0, opacity: opacity)
        }
    }
    
    var isShowRightOutsideShadow = false {
        didSet {
            let opacity: Float = isShowRightOutsideShadow ? 0.5 : 0
            setOutsideShadow(offset: 5.0, opacity: opacity)
        }
    }
    
    // MARK: - private
    private lazy var leftShadow: CAGradientLayer = {
        let shadow = CAGradientLayer()
        shadow.frame = self.bounds
        shadow.frame.size.width = 10
        shadow.colors = [UIColor(white: 0, alpha: 0.5).cgColor, UIColor(white: 0.15, alpha: 0.3).cgColor, UIColor(white: 0, alpha: 0.1).cgColor, UIColor.clear.cgColor]
        shadow.locations = [0.05, 0.5, 0.75, 1]
        shadow.startPoint = CGPoint(x: 0, y: 0.5)
        shadow.endPoint = CGPoint(x: 1, y: 0.5)
        return shadow
    }()
    
    private lazy var rightShadow: CAGradientLayer = {
        let shadow = CAGradientLayer()
        shadow.frame = self.bounds
        shadow.frame.size.width = 10
        shadow.frame.origin.x = self.bounds.size.width - shadow.frame.size.width
        shadow.colors = [UIColor(white: 0, alpha: 0.5).cgColor, UIColor(white: 0, alpha: 0.3).cgColor, UIColor(white: 0, alpha: 0.1).cgColor, UIColor.clear.cgColor]
        shadow.locations = [0.25, 0.5, 0.75, 1]
        shadow.startPoint = CGPoint(x: 1, y: 0.5)
        shadow.endPoint = CGPoint(x: 0, y: 0.5)
        return shadow
    }()
    
    private func setOutsideShadow(offset: CGFloat, opacity: Float) {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: offset, height: 0.0)
        layer.shadowOpacity = opacity
        layer.shadowPath = shadowPath.cgPath
        layer.masksToBounds = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    
    

}
