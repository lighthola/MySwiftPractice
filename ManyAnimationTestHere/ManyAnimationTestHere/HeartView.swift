//
//  HeartView.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/5/4.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit

@IBDesignable
class HeartView: UIView {
    
    lazy var heartPath: UIBezierPath = {
        
        let square        = self.bounds.insetBy(dx: 8 + abs(self.bounds.width - self.bounds.height) * 0.5, dy: 8)
        
        let circleCenterX = square.minX + square.width * 0.25
        let circleCenterY = square.minY + square.height * 0.25
        
        let radius        = circleCenterX - square.minX
        
        let offset        = radius - radius * cos(0.25 * CGFloat.pi)
        let offsetY       = offset * 2
        
        let lCenter       = CGPoint(x: circleCenterX + offset, y: circleCenterY + offsetY)
        let rCenter       = CGPoint(x: circleCenterX + 2 * radius - offset, y: circleCenterY + offsetY)
        
        let peak          = CGPoint(x: square.midX, y: square.maxY / sqrt(2) + offsetY)
        
        let path = UIBezierPath()
        path.addArc(withCenter: lCenter, radius: radius, startAngle: -1.25 * CGFloat.pi, endAngle: -0.25 * CGFloat.pi, clockwise: true)
        path.addArc(withCenter: rCenter, radius: radius, startAngle: -0.75 * CGFloat.pi, endAngle: 0.25 * CGFloat.pi, clockwise: true)
        path.addLine(to: peak)
        path.close()
        
        return path
    }()
    
    lazy var ball: CAShapeLayer = {
        
        let circlePath = UIBezierPath(arcCenter: self.heartPath.currentPoint, radius: 8, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let ball = CAShapeLayer()
        ball.path = circlePath.cgPath
        ball.fillColor = UIColor(white: 0, alpha: 1).cgColor
        
        return ball
    }()
    
    override func draw(_ rect: CGRect) {
        guard let c = UIGraphicsGetCurrentContext() else {
            return
        }
        c.addPath(heartPath.cgPath)
        c.setStrokeColor(UIColor(white: 0, alpha: 0.25).cgColor)
        c.strokePath()
        
        super.draw(rect)
        
        self.layer.addSublayer(ball)
        
    }
}
