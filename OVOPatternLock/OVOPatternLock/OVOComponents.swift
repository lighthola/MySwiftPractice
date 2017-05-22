//
//  Components.swift
//  OVOPatternLock
//
//  Created by Bevis Chen on 2017/5/15.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

@IBDesignable
class OVOCircle: UIView {
    
    var id = ""
    
    var color = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    var shadow: UIColor = UIColor(white: 0, alpha: 0.2) {
        didSet {
            setNeedsDisplay()
        }
    }
    lazy var blur: CGFloat = {
       return min(self.bounds.width, self.bounds.height) / 4
    }()

    override func draw(_ rect: CGRect)
    {
        guard let c = UIGraphicsGetCurrentContext() else {
            fatalError("Current Context NOT Found.")
        }
        
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        let radius = min(rect.width, rect.height) / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        c.saveGState()
        c.setFillColor(color.cgColor)
        c.beginPath()
        c.addPath(path.cgPath)
        c.fillPath()
        c.restoreGState()
        
        
        let invPath = UIBezierPath(cgPath: path.cgPath)
        invPath.append(UIBezierPath(rect: .infinite))
        
        c.saveGState()
        
        c.beginPath()
        c.addPath(path.cgPath)
        c.clip()
        
        c.beginPath()
        c.addPath(invPath.cgPath)
        c.setShadow(offset: .zero, blur: blur, color: shadow.cgColor)
        c.setFillColor(UIColor.white.cgColor)
        c.fillPath(using: .evenOdd)
        
        c.restoreGState()
        
        /*
         lazy property was excuted only once.
         */
        _ = dot
    }
    
    var isSelected = false {
        didSet {
            dot.fillColor = dotColor
            setNeedsDisplay()
        }
    }
    
    private lazy var dot: CAShapeLayer = {
        
        let dot = CAShapeLayer()
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let radius = min(self.bounds.width, self.bounds.height) / 4
        dot.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        dot.fillColor = self.dotColor
        self.layer.addSublayer(dot)
        return dot
    }()
    private var dotColor: CGColor {
        let white: CGFloat = isSelected ? 0.4 : 0.9
        return UIColor(white: white, alpha: 1).cgColor
    }
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Initializer()
    }
    
    convenience init(center: CGPoint, diameter: CGFloat) {
        let rect = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
        self.init(frame: rect)
        self.center = center
        Initializer()
    }
    
    private func Initializer() {
        backgroundColor = .clear
    }
}


// MARK: -
class OVOPattern: UIView {
    
    struct Setting {
        var width: CGFloat = 10
        var cap: CGLineCap = .round
        var join: CGLineJoin = .round
        var color: CGColor = UIColor(white: 0.8, alpha: 1).cgColor
    }
    
    struct Line {
        var from: CGPoint
        var to: CGPoint
    }
    
    var storedLines = [Line]()
    var currentLine: Line? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isClean = false {
        didSet {
            if isClean {
                currentLine = nil
                storedLines.removeAll()
                setNeedsDisplay()
            }
        }
    }
    var test = true
    override func draw(_ rect: CGRect) {
        
        guard let lastLine = currentLine else {
            super.draw(rect)
            return
        }
        
        guard let c = UIGraphicsGetCurrentContext() else {
            fatalError("Current Context NOT Found.")
        }
        
        let setting = Setting()
        c.setLineWidth(setting.width)
        c.setLineCap(setting.cap)
        c.setLineJoin(setting.join)
        c.setStrokeColor(setting.color)
        
        for line in storedLines {
            c.move(to: line.from)
            c.addLine(to: line.to)
        }
        c.move(to: lastLine.from)
        c.addLine(to: lastLine.to)
        c.strokePath()
    }
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializer()
    }
    
    private func initializer() {
        backgroundColor = UIColor.clear
    }
}

class OVOFadePattern: OVOPattern {
    
    override func draw(_ rect: CGRect) {
        
        guard let c = UIGraphicsGetCurrentContext() else {
            fatalError("Current Context NOT Founds.")
        }
        
        guard storedLines.count > 4 else {
            return
        }
        
        let setting = Setting()
        c.setLineWidth(setting.width)
        c.setLineCap(setting.cap)
        c.setLineJoin(setting.join)
        
        /*
         Smooth hand drawing algorithm reference :
         https://code.tutsplus.com/tutorials/smooth-freehand-drawing-on-ios--mobile-13164
         */
        for i in 1...(storedLines.count-1)/3
        {
            let path = UIBezierPath()
            
            for x in 0..<storedLines.count - 3 {
                guard x%3 == 0 && i+x/3 >= (storedLines.count-1)/3 else {
                    continue
                }
                
                path.move(to: storedLines[x].from)
                
                guard i <= 1 else {
                    path.addCurve(to: storedLines[x+3].from, controlPoint1: storedLines[x].to, controlPoint2: storedLines[x+1].to)
                    continue
                }
                // Important!
                storedLines[x+3].from = CGPoint(x: (storedLines[x+1].to.x + storedLines[x+3].to.x)/2.0, y: (storedLines[x+1].to.y + storedLines[x+3].to.y)/2.0)
                path.addCurve(to: storedLines[x+3].from, controlPoint1: storedLines[x].to, controlPoint2: storedLines[x+1].to)
            }
            
            c.setStrokeColor(UIColor(white: 0.33, alpha: 0.33).cgColor)
            c.addPath(path.cgPath)
            c.strokePath()
        }
    }
}

