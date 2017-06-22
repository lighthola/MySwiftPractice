//
//  StrokeLabel.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/4/14.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

class MyView: UIView {
    
}

@IBDesignable
class StrokeLabel: UILabel {
    
    @IBInspectable
    open var strokeColor:UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable
    open var strokeWidth:CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isCut = false {
        didSet{
            //setNeedsLayout()
            //setNeedsDisplay()
        }
    }
    

    override func draw(_ rect: CGRect) {
        
        makeMapPin(rect.size, color: UIColor.green)
        
        super.draw(rect)
        
    }
    
    override func drawText(in rect: CGRect)
    {
        guard let c = UIGraphicsGetCurrentContext() else {
            super.drawText(in: rect)
            return;
        }
        
        let textColor = self.textColor
        c.setLineWidth(strokeWidth)
        c.setLineJoin(.round)
        // 外框
        c.setTextDrawingMode(.stroke)
        self.textColor = strokeColor
        super.drawText(in: rect) // invoke super to draw
        // 文字
        c.setTextDrawingMode(.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }
    
    fileprivate func makeMapPin(_ size: CGSize, color: UIColor)
    {
        let angTopY = size.width * 0.9
        let angBottomY = size.width * 1.4 * 0.9
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.width))
        color.setFill()
        ovalPath.fill()
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: size.width * 0.3, y: angTopY))
        bezierPath.addLine(to: CGPoint(x: size.width * 0.5, y: angBottomY))
        bezierPath.addLine(to: CGPoint(x: size.width * 0.7, y: angTopY))
        bezierPath.addLine(to: CGPoint(x: size.width * 0.3, y: angTopY))
        bezierPath.close()
        color.setFill()
        bezierPath.fill()
    }

}
