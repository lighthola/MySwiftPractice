//
//  LockView.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/5/12.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

@IBDesignable
class LockView: UIView {


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let circle = Circle(at: CGPoint(x: 50, y: 50), size: 50)
        self.addSubview(circle)
        
        let view1 = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        view1.backgroundColor = UIColor(white: 0, alpha: 0.1)
        self.addSubview(view1)
    }

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
    }

}


private class Circle: UIView {
    
    var color = UIColor.black
    
    private var radius: CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        
        let circle = CAShapeLayer()
        //circle.position = CGPoint(x: rect.width / 2, y: rect.height / 2)
        circle.path = UIBezierPath(arcCenter: CGPoint(x: rect.width / 2, y: rect.height / 2), radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        circle.fillColor = UIColor.black.cgColor
//        
//        let colorBaseLayer = CAGradientLayer()
//        colorBaseLayer.frame = rect
//        colorBaseLayer.colors = [UIColor.cyan.cgColor, UIColor.brown.cgColor, UIColor.magenta.cgColor, UIColor.purple.cgColor, UIColor.white.cgColor]
//        colorBaseLayer.locations = [0.0, 0.25, 0.5, 0.75, 1]
//        colorBaseLayer.startPoint = CGPoint.zero // left top
//        colorBaseLayer.endPoint = CGPoint(x: 1, y: 1) // right bottom
        
        //colorBaseLayer.mask = circle
        
        
        UIGraphicsBeginImageContext(rect.size)
        
        guard let c = UIGraphicsGetCurrentContext() else {
            fatalError("Current Context Not Found.")
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.black.cgColor, UIColor.lightGray.cgColor] as CFArray
        let location: [CGFloat] = [0.0, 1.0]
        
        let cgGradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: location)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        c.drawRadialGradient(cgGradient!, startCenter: center, startRadius: 0, endCenter: center, endRadius: CGFloat.pi * 2, options: .drawsAfterEndLocation)
        guard let radialImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("image render failed.")
        }
        UIGraphicsEndImageContext()
        
        circle.backgroundColor = UIColor(patternImage: radialImage).cgColor
        
        layer.addSublayer(circle)
        super.draw(rect)
    }
    
    convenience init(at point: CGPoint, size: Int)
    {
        self.init(frame: CGRect(origin: point, size: CGSize(width: size, height: size)))
        self.radius = CGFloat(size) / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
