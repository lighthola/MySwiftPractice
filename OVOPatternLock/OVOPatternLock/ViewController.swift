//
//  ViewController.swift
//  OVOPatternLock
//
//  Created by Bevis Chen on 2017/5/15.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var patternLock: OVOPatternLock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        patternLock.backgroundColor = UIColor.white
        
        patternLock.toDeliverKey = { [unowned self] key in
            print("callback: \(key)")
            if key == "1-2-3-4" {
                self.patternLock.isHidden = true
            }
        }
        //patternLock.isHidden = true
        
//        _ = pattern
//        _ = pan
    }
    private lazy var pattern: OVOPattern = {
        let temp = OVOFadePattern(frame: self.view.bounds)
        self.view.addSubview(temp)
        return temp
    }()
    private lazy var pan: OVOGestureRecognizer = {
        return OVOGestureRecognizer(view: self.view, type: .Pan) { (nizer) in
            print(nizer.location(in: self.view))
            
            guard nizer.state != .ended else {
                print("END")
//                print(self.key)
//                self.toDeliverKey?(self.key)
//                self.cleanPattern()
                return
            }

            var toPoint = nizer.location(in: self.view)
            
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
    }()
    
    private var fromPoint: CGPoint = .zero
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

