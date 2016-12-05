//
//  ViewController.swift
//  BaseAnimationPractice
//
//  Created by Bevis Chen on 2016/12/1.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var view1: UIView! {
        didSet {
            UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
                
                self.view1.transform = CGAffineTransform(translationX: 100, y: -100).scaledBy(x: 1.5, y: 1.5).rotated(by: CGFloat(M_PI))
            }, completion: nil)
        }
    }
    @IBOutlet weak var view2: UIView! {
        didSet {
            view2.isHidden = true
        }
    }
    @IBOutlet weak var view3: UIView! {
        didSet {
            UIView.animate(withDuration: 1.3, delay: 3, options: [.allowAnimatedContent], animations: {
                self.view3.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.view3.backgroundColor = UIColor.cyan
            }) { (isFinish) in
                UIView.animate(withDuration: 1, animations: {
                    self.view3.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                    self.view3.backgroundColor = UIColor(red: 19 / 255, green: 144 / 255, blue:  242 / 255, alpha: 1)
                }, completion: { (isFinish) in
                    
                    // recursive in didSet
                    self.view3 = self.view3
                })
            }
        }
    }
    @IBOutlet weak var view4: UIView! {
        didSet {
            
        }
    }
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view2Animation()
        view4Animation()
        view5Animation()
        view6Animation()
    }
    
    // MARK:- Animation
    func view2Animation() {
        
        // Transition can't be call on didSet.
        UIView.transition(with: view2, duration: 1, options: [.transitionCurlDown, .repeat], animations: {
            
            self.view2.isHidden = false
            
        }) { (finish) in
            print("view2 finish")
        }
    }

    func view4Animation() {

        let tmpView: UIView = UIView(frame: view4.bounds)
        tmpView.backgroundColor = UIColor.purple
        
        // delay on view transition
        delay(3) {
            UIView.transition(with: self.view4, duration: 1.5, options: [.transitionFlipFromLeft, .curveEaseIn], animations: {
                
                self.view4.addSubview(tmpView)
                
            }) { (isFinish) in
                tmpView.removeFromSuperview()
                self.view4Animation()
            }
        }
    }
    
    func view5Animation() {
        
        let tmpView: UIView = UIView(frame: view4.bounds)
        tmpView.backgroundColor = UIColor.red
        
        UIView.transition(with: self.view5, duration: 1.5, options: [.transitionCurlUp, .curveEaseIn, .repeat], animations: {
            
            self.view5.addSubview(tmpView)
            
        }) { (isFinish) in
            
        }
    }
    
    func view6Animation() {
        
        let tmpView: UIView = UIView(frame: view6.frame)
        tmpView.backgroundColor = UIColor.red
        
        // remove view6 then add tmpView
        delay(3) {
            UIView.transition(from: self.view6, to: tmpView, duration: 2, options: [.transitionCurlUp]) { (isFinish) in
                
                // "view7" layout will different after finish, because Autolayout.
            }
        }
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- Helper
extension ViewController {
    
    // performSelector on Swift 3
    func delay(_ when: Double, execute: @escaping ()->Void) {
        let time = DispatchTime.now() + when
        DispatchQueue.main.asyncAfter(deadline: time, execute: execute)
    }
}

