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
    var transationIndex = 0
    var backgroundLayer = CALayer()
    var flipLayer = CATransformLayer()
    
    // MARK:- Constant
    
    
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shape.backgroundColor = UIColor.black
        
        setFlipLayer()
    }
    
    // MARK: - Set UI
    private func setFlipLayer () {
        
        var newRect = self.shape.bounds
        
        //        backgroundLayer.frame = newRect
        //        backgroundLayer.zPosition = -300000
        //
        //        self.shape.layer.addSublayer(backgroundLayer)
        //
        //        let topLayer = CALayer()
        newRect.size.height /= 2
        //        topLayer.frame = newRect
        //        topLayer.backgroundColor = UIColor.black.cgColor
        //        topLayer.masksToBounds = true
        //        topLayer.contentsGravity = kCAGravityBottom
        //
        //        self.backgroundLayer.addSublayer(topLayer)
        //
        //        let bottomLayer = CALayer()
        //        newRect.origin.y = newRect.size.height
        //        bottomLayer.frame = newRect
        //        bottomLayer.backgroundColor = UIColor.brown.cgColor
        //        bottomLayer.masksToBounds = true
        //        bottomLayer.contentsGravity = kCAGravityTop
        //
        //        self.backgroundLayer.addSublayer(bottomLayer)
        
        newRect.origin.y = newRect.size.height / 2
        flipLayer.frame = newRect
        // default is (0.5, 0.5), center for super view.
        flipLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        self.shape.layer.addSublayer(flipLayer)
        
        let backLayer = CALayer()
        backLayer.frame = flipLayer.bounds
        backLayer.isDoubleSided = false
        backLayer.masksToBounds = true
        backLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0)
        
        flipLayer.addSublayer(backLayer)
        
        let frontLayer = CALayer()
        frontLayer.frame = flipLayer.bounds
        frontLayer.isDoubleSided = false
        frontLayer.masksToBounds = true
//        frontLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0)
        
        flipLayer.addSublayer(frontLayer)
        
        frontLayer.contentsGravity = kCAGravityTop
        frontLayer.backgroundColor = UIColor.purple.cgColor
        backLayer.contentsGravity  = kCAGravityBottom
        backLayer.backgroundColor = UIColor.orange.cgColor
//        var transform = CATransform3DMakeRotation(CGFloat(0), 1, 0, 0)
//        transform.m34 = 1.0 / 500
//        flipLayer.transform = transform
    }
    
    private func clearFlipLayer() {
        
        backgroundLayer.removeFromSuperlayer()
        backgroundLayer = CALayer()
        flipLayer.removeFromSuperlayer()
        flipLayer = CATransformLayer()
    }
    
    // MARK:- CAAnimationDelegate Methods
    func animationDidStart(_ anim: CAAnimation) {
        
//        showLog()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        showLog()
    }
    
    private func showLog() {
        
//        print(self.shape.layer.bounds)
//        print(self.shape.layer.position)
//        print(self.shape.center)
        print(self.shape.frame)
        print(self.shape.bounds)
    }
    
    // MARK:- IBAction Methods
    @IBAction func CATransationBtnPressed(_ sender: UIButton) {
        
//        clearFlipLayer()
//        setFlipLayer()
        
        var t = CATransform3DIdentity
        t.m34 = -1.0 / 500.0 //Adds depth to the animation
        let angle = CGFloat(transationIndex % 2 == 0 ? M_PI : 0)
        t = CATransform3DRotate(t, angle, 1, 0, 0)
        
//        flipLayer.removeAllAnimations()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        self.flipLayer.transform = t
        CATransaction.commit()
        
        transationIndex += 1
    }
    
    @IBAction func CABaseAnimationBtnPressed(_ sender: UIButton) {
        
        showLog()
        
        //
        CATransaction.setDisableActions(true)
        
        let animation1 = CABasicAnimation(keyPath: "position")
        animation1.fromValue = self.shape.layer.position
        animation1.toValue = CGPoint(x: self.shape.layer.position.x, y: self.shape.layer.position.y + 100)
        
        // default is 0
        let animation2 = CABasicAnimation(keyPath: "transform.rotation.z")
        animation2.fromValue = 0
        animation2.toValue =  M_PI * 12
        
        // default is 1
        let animation3 = CABasicAnimation(keyPath: "transform.scale.x")
        animation3.fromValue = 0
        animation3.toValue = 1
        
        let animation4 = CABasicAnimation(keyPath: "transform.translation.x")
        animation4.fromValue = 0
        animation4.toValue = 100
        
        let animation5 = CABasicAnimation(keyPath: "bounds.size.height")
        animation5.fromValue = self.shape.layer.bounds.size.height
        animation5.toValue = 0
        
        let animationGroup = CAAnimationGroup()
        // set view stay at final point when animation complete
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        // -
        animationGroup.duration = 1
        animationGroup.repeatCount = 1
        animationGroup.animations = [animation2, animation4]
        animationGroup.delegate = self
        
        self.shape.layer.add(animationGroup, forKey: "AnimationGO")
    }
    
    @IBAction func transformBtnPressed(_ sender: UIButton) {
        
        print(self.shape.frame)
        
        let isEven = self.transformIndex % 2 == 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            
            print(self.shape.transform)
            let transform1 = self.shape.transform.translatedBy(x: 0, y: 50).rotated(by: CGFloat(M_PI / 20))
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
