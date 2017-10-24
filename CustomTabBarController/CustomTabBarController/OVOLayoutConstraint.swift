//
//  OVOLayoutConstraint.swift
//  CustomTabBarController
//
//  Created by Bevis Chen on 2017/5/25.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: Size
    @discardableResult func width(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func height(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func size(_ size: CGSize) -> [String: NSLayoutConstraint] {
        let constraint1 = width(size.width)
        let constraint2 = height(size.height)
        return ["width": constraint1, "height": constraint2]
    }
    
    @discardableResult func equalWidth(to view: UIView, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func equalHeight(to view: UIView, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func equalSize(to view: UIView, in parent: UIView) -> [String: NSLayoutConstraint] {
        let width = equalWidth(to: view, in: parent)
        let height = equalHeight(to: view, in: parent)
        return ["width": width, "height": height]
    }
    
    // MARK: - Center
    @discardableResult func centerH(in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: 0)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func centerV(in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1, constant: 0)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func center(in parent: UIView) -> [String: NSLayoutConstraint] {
        let h = centerH(in: parent)
        let v = centerV(in: parent)
        return ["h": h, "v": v]
    }
    
    // MARK: - Distance (In)
    @discardableResult func top(_ distance: CGFloat, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func bottom(_ distance: CGFloat, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func left(_ distance: CGFloat, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func right(_ distance: CGFloat, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func leftRight(_ distance: CGFloat, in parent: UIView) -> [String: NSLayoutConstraint] {
        let leftD = left(distance, in: parent)
        let rightD = right(distance, in: parent)
        return ["left": leftD, "right": rightD]
    }
    
    @discardableResult func topBottom(_ distance: CGFloat, in parent: UIView) -> [String: NSLayoutConstraint] {
        let topD = top(distance, in: parent)
        let bottomD = bottom(distance, in: parent)
        return ["top": topD, "bottom": bottomD]
    }
    
    @discardableResult func distanceAll(_ distance: CGFloat, in parent: UIView) -> [String: NSLayoutConstraint] {
        let topD = top(distance, in: parent)
        let bottomD = bottom(distance, in: parent)
        let leftD = left(distance, in: parent)
        let rightD = right(distance, in: parent)
        return ["top": topD, "bottom": bottomD, "left": leftD, "right": rightD]
    }
    
    // MARK: - Distance (To)
    @discardableResult func top(_ distance: CGFloat, to view: UIView, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func bottom(_ distance: CGFloat, to view: UIView, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func left(_ distance: CGFloat, to view: UIView, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func right(_ distance: CGFloat, to view: UIView, in parent: UIView) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: distance)
        parent.addConstraint(constraint)
        return constraint
    }
}
