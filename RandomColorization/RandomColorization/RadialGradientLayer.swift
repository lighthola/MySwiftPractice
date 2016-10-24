//
//  RadialGradientLayer.swift
//  RandomColorization
//
//  Created by Bevis Chen on 2016/10/21.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class RadialGradientLayer: CALayer {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    var startCenter = CGPoint.zero
    var endCenter = CGPoint.zero
    var startRadius: CGFloat = 0.0
    var endRadius: CGFloat = 0.0
    var colors: [CGColor] = [UIColor.black.cgColor , UIColor.gray.cgColor]
    var locations:[CGFloat] = [0.0, 1.0]
    
    // MARK:- Constant
    
    
    // MARK:-
    
    override init() {
        super.init()

        needsDisplayOnBoundsChange = true
    }
    
    convenience init(center:CGPoint, radius:CGFloat, colors:[CGColor], locations:[CGFloat]) {
        self.init()
        
        self.startCenter = center
        self.endCenter = center
        self.endRadius = radius
        self.colors = colors
        self.locations = locations
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        ctx.drawRadialGradient(gradient!, startCenter: startCenter, startRadius: startRadius, endCenter: endCenter, endRadius: endRadius, options: .drawsAfterEndLocation)
    }
}
