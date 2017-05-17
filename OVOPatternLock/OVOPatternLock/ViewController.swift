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
        
        patternLock.deliverKey = { [unowned self] key in
            print("callback: \(key)")
            if key == "1234" {
                self.patternLock.isHidden = true
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

