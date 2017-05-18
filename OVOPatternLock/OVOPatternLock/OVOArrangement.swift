//
//  OVOArrangement.swift
//  OVOPatternLock
//
//  Created by Bevis Chen on 2017/5/18.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

protocol OVOArrangement {
    var circles: [OVOCircle]{ get set }
}

class OVORoundArrangement: OVOArrangement {
    
    init(rect: CGRect, settings: Settings = .Three, toArrange: @escaping (OVOCircle)->()) {
        self.rect = rect
        self.settings = settings
        self.toArrange = toArrange
        
        _ = circles
    }
    
    // MARK: - Pattern Base Setting
    enum Settings: Int {
        case Three = 3
        case Four
        case Five
        
        var amount: Int {
            return self.rawValue * self.rawValue
        }
        var padding: CGFloat {
            return 32
        }
        var intervalCount: CGFloat {
            return CGFloat(self.rawValue) * 2 - 1
        }
        func circleDiameterBy(_ rect: CGRect) -> CGFloat {
            let length = min(rect.width, rect.height)
            return (length - padding * 2) / intervalCount
        }
        func roundSettingBy(_ rect: CGRect) -> (center: CGPoint, radius:CGFloat) {
            let center = CGPoint(x: rect.width/2, y: rect.height/2)
            let radius = (min(rect.width, rect.height) - padding) / 2 - circleDiameterBy(rect) / 2
            return (center, radius)
        }
    }
    
    private var rect: CGRect
    private var toArrange: (OVOCircle)->()
    var settings: Settings = .Three
    
    lazy var circles: [OVOCircle] = {
        
        let padding  = self.settings.padding
        let amount   = self.settings.amount
        let diameter = self.settings.circleDiameterBy(self.rect)
        let roundCenter = self.settings.roundSettingBy(self.rect).center
        let roundRadius = self.settings.roundSettingBy(self.rect).radius
        
        var temp = [OVOCircle]()
        for i in 0..<self.settings.amount {
            
            let circlePosition = self.caculateCircleCenter(amount: CGFloat(amount), number: CGFloat(i), center: roundCenter, radius: roundRadius)
            let circle = OVOCircle(center: circlePosition, diameter: diameter)
            circle.id = String(i)
            temp.append(circle)
            
            // callback to pattern lock to add
            self.toArrange(circle)
        }
        return temp
    }()
    
    func caculateCircleCenter(amount: CGFloat, number: CGFloat, center: CGPoint, radius: CGFloat) -> CGPoint {
        let angleStep = 2 * .pi / amount
        let xPos = cos(angleStep * number) * radius
        let yPos = sin(angleStep * number) * radius
        return CGPoint(x: center.x + xPos, y: center.y + yPos)
    }
}

class OVONormalArrangement: OVOArrangement {
    
    init(rect: CGRect, settings: Settings = .Three, toArrange: @escaping (OVOCircle)->()) {
        self.rect = rect
        self.settings = settings
        self.toArrange = toArrange
        
        _ = circles
    }
    
    // MARK: - Pattern Base Setting
    enum Settings: Int {
        case Three = 3
        case Four
        case Five
        
        var amount: Int {
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
    
    var settings: Settings = .Three
    
    // Pattern lock bounds
    private var rect: CGRect
    private var toArrange: (OVOCircle)->()
    
    lazy var circles: [OVOCircle] = {
        
        // Arranging circle's position
        let padding       = self.settings.padding
        let height        = self.settings.patternHeightBy(self.rect.height)
        let intervalCount = self.settings.intervalCount
        let intervalY     = height / intervalCount
        let diameter      = self.settings.circleDiameterBy(self.rect.width)
        
        var temp = [OVOCircle]()
        for i in 0..<self.settings.amount {
            let rows   = CGFloat(i % self.settings.rawValue)
            let x      = padding + rows * 2 * diameter + diameter / 2
            let cloums = CGFloat(i / self.settings.rawValue)
            let y      = 2 * padding + intervalY * 0.5 + cloums * 2 * intervalY
            let center = CGPoint(x: x, y: y)
            let circle = OVOCircle(center: center, diameter: diameter)
            circle.id  = String(i)
            temp.append(circle)
            
            // callback to return a circle, then pattern lock is going to add as a subview.
            self.toArrange(circle)
        }
        return temp
    }()
    
}
