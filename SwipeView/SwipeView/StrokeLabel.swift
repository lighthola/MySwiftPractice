//
//  StrokeLabel.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/4/14.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

@IBDesignable
class StrokeLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
    
    override func drawText(in rect: CGRect)
    {
        guard let c = UIGraphicsGetCurrentContext() else {
            super.drawText(in: rect)
            return;
        }
        
        let textColor = self.textColor
        c.setLineWidth(strokeWidth)
        c.setLineJoin(.round)
        
        c.setTextDrawingMode(.stroke)
        self.textColor = strokeColor
        super.drawText(in: rect)
        
        c.setTextDrawingMode(.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }

}
