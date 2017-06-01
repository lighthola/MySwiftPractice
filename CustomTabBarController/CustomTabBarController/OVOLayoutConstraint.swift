//
//  OVOLayoutConstraint.swift
//  CustomTabBarController
//
//  Created by Bevis Chen on 2017/5/25.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class OVOLayoutConstraint: NSLayoutConstraint {
    
    public class func centerIn(_ parent:UIView, attached: UIView, size: CGSize? = nil) {
        
        parent.addSubview(attached)
        
        parent.translatesAutoresizingMaskIntoConstraints = false
        attached.translatesAutoresizingMaskIntoConstraints = false
        
        /*
         https://stackoverflow.com/questions/12873372/centering-a-view-in-its-superview-using-visual-format-language
        */
        var vFormat = "V:[parent]-(<=1)-[attached]"
        var hFormat = "H:[parent]-(<=1)-[attached]"
        
        if let width = size?.width, let height = size?.height  {
            vFormat = "V:[parent]-(<=1)-[attached(\(width))]"
            hFormat = "H:[parent]-(<=1)-[attached(\(height))]"
        }
        
        // Center horizontally
        var constraints = NSLayoutConstraint.constraints(
            withVisualFormat: vFormat,
            options: .alignAllCenterX,
            metrics: nil,
            views: ["parent":parent, "attached":attached])
        
        parent.addConstraints(constraints)
        
        // Center vertically
        constraints = NSLayoutConstraint.constraints(
            withVisualFormat: hFormat,
            options: .alignAllCenterY,
            metrics: nil,
            views: ["parent":parent, "attached":attached])
        
        parent.addConstraints(constraints)
        
        //let h = NSLayoutConstraint(item: attached, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: 0)
        //parent.addConstraint(h)
        //let v = NSLayoutConstraint(item: attached, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1, constant: 0)
        //parent.addConstraint(v)
    }
    
    public class func sameSizeWith(_ parent: UIView, attached: UIView) {
    
        parent.addSubview(attached)

        parent.translatesAutoresizingMaskIntoConstraints = false
        attached.translatesAutoresizingMaskIntoConstraints = false
        
        let v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .alignAllLeft, metrics: nil, views: ["view": attached])
        let h = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .alignAllLeft, metrics: nil, views: ["view": attached])
        parent.addConstraints(v)
        parent.addConstraints(h)
    }
}
