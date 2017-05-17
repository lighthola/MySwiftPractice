//
//  OVOPatternLock.swift
//  OVOPatternLock
//
//  Created by Bevis Chen on 2017/5/15.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

@IBDesignable
class OVOPatternLock: UIView {
    
    // MARK: - Pattern Base Setting
    enum Settings: Int {
        case Three = 3
        case Four
        case Five
        
        var size: Int {
            return self.rawValue * self.rawValue
        }
        var padding: CGFloat {
            return 32
        }
        var intervalCount: CGFloat {
            return CGFloat(self.rawValue) * 2 - 1
        }
        func patternHeightBy(_ height: CGFloat)-> CGFloat {
            return height - 4 * padding
        }
        func circleDiameterBy(_ width: CGFloat) -> CGFloat {
            return (width - padding * 2) / intervalCount
        }
    }
    
    @IBInspectable
    var size: Int = 3 {
        willSet(newSize) {
            if newSize < 3 {
                self.size = 3
            }
            else if newSize > 5 {
                self.size = 5
            }
        }
        didSet {
            setNeedsDisplay()
            settings = Settings(rawValue: size)!
        }
    }
    private var settings: Settings = .Three
    
    private lazy var circles: [OVOCircle] = {
        
        let padding       = self.settings.padding
        let height        = self.settings.patternHeightBy(self.bounds.height)
        let intervalCount = self.settings.intervalCount
        let intervalY     = height / intervalCount
        let diameter      = self.settings.circleDiameterBy(self.bounds.width)
        
        var temp = [OVOCircle]()
        for i in 0..<self.settings.size {
            let rows   = CGFloat(i % self.size)
            let x      = padding + rows * 2 * diameter + diameter / 2
            let cloums = CGFloat(i / self.size)
            let y      = 2 * padding + intervalY * 0.5 + cloums * 2 * intervalY
            let center = CGPoint(x: x, y: y)
            let circle = OVOCircle(center: center, diameter: diameter)
            circle.id  = String(i)
            self.addSubview(circle)
            temp.append(circle)
        }
        return temp
    }()
    
    // MARK: - Gesture Recognizer
    private lazy var tap: OVOGestureRecognizer = {
        return OVOGestureRecognizer(view: self, type: .Tap) { (nizer) in
            print(nizer.location(in: self))
            let point = nizer.location(in: self)
            
            for circle in self.circles {
                if circle.frame.contains(point) {
                    circle.isSelected = true
                }
            }
       }
    }()
    
    private lazy var pan: OVOGestureRecognizer = {
        return OVOGestureRecognizer(view: self, type: .Pan) { (nizer) in
            print(nizer.location(in: self))
            
            guard nizer.state != .ended else {
                print("END")
                print(self.key)
                self.deliverKey?(self.key)
                self.cleanPattern()
                return
            }
            
            var toPoint = nizer.location(in: self)
            var isDrawing = false
            for circle in self.circles {
                if circle.frame.contains(toPoint)
                {
                    circle.isSelected = true
                    
                    if self.fromPoint != .zero
                    {
                        if self.fromPoint != circle.center {
                            let stroedLine = OVOPattern.Line(from: self.fromPoint, to: circle.center)
                            self.pattern.storedLines.append(stroedLine)
                            self.key += circle.id
                        }
                        toPoint = circle.center
                        print(self.pattern.storedLines.count)
                    }
                    else {
                        self.key += circle.id
                    }
                
                    self.fromPoint = circle.center
                }
            }
            
            if self.fromPoint != .zero {
                self.pattern.currentLine = OVOPattern.Line(from: self.fromPoint, to: toPoint)
            }
        }
    }()
    
    private var fromPoint: CGPoint = .zero
    private lazy var pattern: OVOPattern = {
        let temp = OVOPattern(frame: self.bounds)
        self.addSubview(temp)
        return temp
    }()
    
    private func cleanPattern() {
        self.pattern.isClean = true
        self.fromPoint = .zero
        self.key = ""
        for circle in circles {
            circle.isSelected = false
        }
    }
    
    private var key: String = ""
    var deliverKey:((String)->())?
    
    
    override func draw(_ rect: CGRect) {
        _ = circles
        _ = tap
        _ = pan
        _ = pattern
    }
    
    
    // MARK: - Initializer
    convenience init(frame: CGRect, size: Int = 3, getKey: @escaping (String)->()) {
        self.init(frame: frame)
        self.size = size
        deliverKey = getKey
        Initializer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Initializer()
    }
    
    private func Initializer() {
        
    }
}

// MARK: -

