//
//  CoreGraphicsTest.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/5/10.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

class CoreGraphicsTest: UIView {


    override func draw(_ rect: CGRect) {
        
        let radius          = rect.height * 0.25
        let centerX         = rect.width  * 0.5
        let centerY         = rect.height * 0.5
        let arcCenterOffset = radius - radius * 0.5 * sqrt(3)
        let degree:(_: CGFloat) -> CGFloat = {
            return CGFloat.pi * $0 / 180
        }
        
        let gourd   = UIBezierPath()
        let circle1 = UIBezierPath(arcCenter: CGPoint(x: centerX - radius + arcCenterOffset, y: centerY), radius: radius, startAngle: degree(-30), endAngle: degree(30), clockwise: false)
        let circle2 = UIBezierPath(arcCenter: CGPoint(x: centerX + radius - arcCenterOffset, y: centerY ), radius: radius, startAngle: degree(150), endAngle: degree(-150), clockwise: false)
        gourd.append(circle1)
        gourd.append(circle2)

        let gourdInverse = UIBezierPath(cgPath: gourd.cgPath)
        let infiniteRect = UIBezierPath(rect: .infinite)
        gourdInverse.append(infiniteRect)
        
        guard let c = UIGraphicsGetCurrentContext() else {
            fatalError("current context not found.")
        }
        
        c.saveGState()
        // stroke
        c.setStrokeColor(UIColor(white: 0, alpha: 1).cgColor)
        c.beginPath()
        c.addPath(gourd.cgPath)
        c.strokePath()
        
        c.restoreGState()
        
        c.saveGState()
        
        // Here are two ways as follows:
        // 1. even odd
//        c.beginPath()
//        c.addPath(gourdInverse.cgPath)
//        c.setShadow(offset: CGSize.zero, blur: 10, color: UIColor.red.cgColor)
//        c.setFillColor(UIColor(white: 1, alpha: 1).cgColor)
//        c.fillPath(using: .evenOdd)
        
        // 2. clip
        c.beginPath()
        c.addPath(gourd.cgPath)
        c.clip()
        
        c.beginPath()
        c.addPath(gourdInverse.cgPath)
        c.setShadow(offset: CGSize.zero, blur: 10, color: UIColor.red.cgColor)
        c.fillPath(using: .evenOdd)
        
        c.restoreGState()
        
        // cross line in view
        c.fill(CGRect(x: centerX - 0.5, y: 0, width: 1, height: rect.height))
        c.fill(CGRect(x: 0, y: centerY - 0.5, width: rect.width, height: 1))
        
        super.draw(rect)
    }

}
