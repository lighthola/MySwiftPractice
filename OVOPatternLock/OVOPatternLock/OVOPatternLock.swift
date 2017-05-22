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
    
    // MARK: - Pattern Arrangement Settings
    
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
        }
    }
    
    @IBInspectable
    var isRoundMode: Bool = false
    
    @IBInspectable
    var isFadePattern: Bool = false
    
    @IBInspectable
    var circleColor: UIColor?
    
    @IBInspectable
    var shadowColor: UIColor?
    
    private lazy var arrangement: OVOArrangement = {
        
        if self.isRoundMode {
            let settings = OVORoundArrangement.Settings(rawValue: self.size)!
            return OVORoundArrangement(rect: self.bounds, settings: settings, toArrange: self.toArrange)
        }
        else {
            let settings = OVONormalArrangement.Settings(rawValue: self.size)!
            return OVONormalArrangement(rect: self.bounds, settings: settings, toArrange: self.toArrange)
        }
    }()
    
    private func toArrange(circle: OVOCircle)->() {
        
        if let color = circleColor {
            circle.color = color
        }
        
        if let shadow = shadowColor {
            circle.shadow = shadow
        }

        self.addSubview(circle)
    }

    // MARK: - Gesture Recognizer Settings
    private lazy var tap: OVOGestureRecognizer = {
        return OVOGestureRecognizer(view: self, type: .Tap) { (nizer) in
            print(nizer.location(in: self))
            let point = nizer.location(in: self)
            
            for circle in self.arrangement.circles {
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
                self.toDeliverKey?(self.key)
                self.cleanPattern()
                return
            }
            
            var toPoint = nizer.location(in: self)
            
            if self.isFadePattern {
                for circle in self.arrangement.circles {
                    if circle.frame.contains(toPoint)
                    {
                        if self.lastFadePatternMatchCirclePoint == circle.center {
                            break
                        }
                        
                        circle.isSelected = true
                        if self.lastFadePatternMatchCirclePoint != nil {
                            self.key += "-" + circle.id
                        }
                        else {
                            self.key += circle.id
                        }
                        
                        self.lastFadePatternMatchCirclePoint = circle.center
                    }
                }
                
                guard self.fromPoint != .zero else {
                    self.fromPoint = toPoint
                    return
                }
                
                if self.pattern.storedLines.count >= 10 {
                    self.pattern.storedLines.removeFirst()
                }
                let line = OVOPattern.Line(from: self.fromPoint, to: toPoint)
                self.pattern.storedLines.append(line)
                self.fromPoint = toPoint
                self.pattern.setNeedsDisplay()
            }
            else {
                var isDrawing = false
                for circle in self.arrangement.circles {
                    if circle.frame.contains(toPoint)
                    {
                        circle.isSelected = true
                        
                        if self.fromPoint != .zero
                        {
                            if self.fromPoint != circle.center {
                                let stroedLine = OVOPattern.Line(from: self.fromPoint, to: circle.center)
                                self.pattern.storedLines.append(stroedLine)
                                self.key += "-" + circle.id
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
                
                // Drawing lines by call setNeedsDisplay() to call draw(rect:)
                if self.fromPoint != .zero {
                    self.pattern.currentLine = OVOPattern.Line(from: self.fromPoint, to: toPoint)
                }
            }
        }
    }()
    
    private var lastFadePatternMatchCirclePoint: CGPoint?
    private var fromPoint: CGPoint = .zero
    private lazy var pattern: OVOPattern = {
        let temp = self.isFadePattern ? OVOFadePattern(frame: self.bounds) : OVOPattern(frame: self.bounds)
        self.addSubview(temp)
        return temp
    }()
    
    // MARK: - Action for gesture
    private func cleanPattern() {
        self.pattern.isClean = true
        self.fromPoint = .zero
        self.key = ""
        for circle in arrangement.circles {
            circle.isSelected = false
        }
        
        // for fade pattern
        self.lastFadePatternMatchCirclePoint = nil
    }
    
    private var key: String = ""
    var toDeliverKey:((String)->())?
    
    
    // MARK: -
    override func draw(_ rect: CGRect) {
        _ = arrangement
        _ = tap
        _ = pan
        _ = pattern
    }
    
    
    // MARK: - Initializer
    convenience init(frame: CGRect, size: Int = 3, getKey: @escaping (String)->()) {
        self.init(frame: frame)
        self.size = size
        toDeliverKey = getKey
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

