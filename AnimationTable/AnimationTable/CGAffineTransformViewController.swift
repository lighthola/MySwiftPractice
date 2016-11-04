//
//  CGAffineTransformViewController.swift
//  AnimationTable
//
//  Created by Bevis Chen on 2016/11/3.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import QuartzCore

class CGAffineTransformViewController: UIViewController, CAAnimationDelegate {

    // MARK:- IBOutlet
    @IBOutlet weak var shape: UIView!
    
    
    // MARK:- Variable
    var transformIndex = 0
    
    // MARK:- Constant
    
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func CABaseAnimationBtnPressed(_ sender: UIButton) {
        
        let animation1 = CABasicAnimation(keyPath: "position")
        animation1.fromValue = self.shape.layer.position
        animation1.toValue = CGPoint(x: self.shape.layer.position.x, y: self.shape.layer.position.y + 100)
        
        let animation2 = CABasicAnimation(keyPath: "transform.rotation.y")
        animation2.fromValue = 0
        animation2.toValue = 5 * M_PI
        
        let animation3 = CABasicAnimation(keyPath: "bounds.origin.y")
        animation3.fromValue = self.shape.layer.bounds.origin.y
        animation3.toValue = self.shape.layer.bounds.origin.y + 100
        
        let animationGroup = CAAnimationGroup()
        // set view stay at final point when animation complete
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        // -
        animationGroup.duration = 1
        animationGroup.repeatCount = 1
        animationGroup.animations = [ animation3, animation2, ]
        animationGroup.delegate = self
        
        self.shape.layer.bounds.origin.y = self.shape.layer.bounds.origin.y + 100
        
        self.shape.layer.add(animationGroup, forKey: "AnimationGO")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print(self.shape.layer.frame)
        print(self.shape.layer.position)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(self.shape.layer.frame)
        print(self.shape.layer.position)
    }
    
    
    // MARK:- IBAction Methods
    @IBAction func transformBtnPressed(_ sender: UIButton) {
        
        print(self.shape.frame)
        
        let isEven = self.transformIndex % 2 == 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            
            print(self.shape.transform)
            let transform1 = self.shape.transform.translatedBy(x: 0, y: isEven ? 50 : 50).rotated(by: CGFloat(M_PI / 180.0 * (isEven ? 180 : 0)))
            self.shape.transform = transform1
            
        }, completion: { (finish) in
//            self.shape.transform = CGAffineTransform.identity
            if self.transformIndex < 10 {
//                self.transformBtnPressed(sender)
            }
            
            self.transformIndex += 1
            print(self.shape.frame)
        })
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
