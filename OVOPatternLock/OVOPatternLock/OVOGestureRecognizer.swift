//
//  OVOGestureRecognizer.swift
//  OVOPatternLock
//
//  Created by Bevis Chen on 2017/5/16.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class OVOGestureRecognizer: NSObject {
    
    enum GestureType {
        case Tap
        case Pan
        case Swipe
        case Pinch
        case Rotation
        case LongPress
    }
    
    var gesture: UIGestureRecognizer?
    
    var closure: (UIGestureRecognizer)->()
    
    init(view: UIView, type: GestureType, closure: @escaping ( UIGestureRecognizer)->()) {
        self.closure = closure
        super.init()
        
        switch type {
        case .Tap:
            gesture = UITapGestureRecognizer()
        case .Pan:
            gesture = UIPanGestureRecognizer()
        case .Swipe:
            gesture = UISwipeGestureRecognizer()
        case .Pinch:
            gesture = UIPinchGestureRecognizer()
        case .Rotation:
            gesture = UIRotationGestureRecognizer()
        case .LongPress:
            gesture = UILongPressGestureRecognizer()
        }
        
        guard let gesture = self.gesture  else {
            fatalError("OVOGestureRecognizer failed to initialize.")
        }
        
        gesture.addTarget(self, action: #selector(invokeTarget(nizer:)))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
    }
    
    func invokeTarget(nizer: UIGestureRecognizer) {
        self.closure(nizer)
    }
}
