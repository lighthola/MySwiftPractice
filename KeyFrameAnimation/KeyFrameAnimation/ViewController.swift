//
//  ViewController.swift
//  KeyFrameAnimation
//
//  Created by Bevis Chen on 2016/12/5.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var hogRider: UIImageView! {
        didSet {
            // up the zPosition to half width
            self.hogRider.layer.zPosition = 25
        }
    }
    
    // MARK:- 

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateKeyframes(withDuration: 5, delay: 2, options: [.repeat, .autoreverse], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                
                self.hogRider.center.x += 120
                self.hogRider.center.y -= 150
                self.hogRider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * -1))
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                
                self.hogRider.center.x -= 60
                self.hogRider.center.y -= 150
                self.hogRider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * -1)).rotated(by: CGFloat(M_PI * -1))
                
                self.hogRider.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI * 3), 0, 1, 0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                
                self.hogRider.center.x += 100
                self.hogRider.center.y -= 100
                self.hogRider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * -1)).rotated(by: CGFloat(M_PI * -1)).rotated(by: CGFloat(M_PI * -1)).scaledBy(x: 1.5, y: 1.5)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.25, animations: {
                
                self.hogRider.center.x += 120
                self.hogRider.center.y -= 60
                self.hogRider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * -1)).rotated(by: CGFloat(M_PI * -1)).rotated(by: CGFloat(M_PI * -1)).rotated(by: CGFloat(M_PI * -1))
            })
            
        }) { (isFinish) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

