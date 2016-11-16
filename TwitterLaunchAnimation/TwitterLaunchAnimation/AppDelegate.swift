//
//  AppDelegate.swift
//  TwitterLaunchAnimation
//
//  Created by Bevis Chen on 2016/11/14.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mask = CALayer()
        mask.contents = UIImage(named: "twitter")?.cgImage
        mask.contentsGravity = kCAGravityResizeAspect
        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        mask.position = self.window!.center
        self.window?.rootViewController?.view.layer.mask = mask
        self.window?.backgroundColor = UIColor(red: 18/255, green: 145/255, blue: 242/255, alpha: 1)
        
        animateMask(mask)
        
        return true
    }
    
    private func animateMask(_ mask: CALayer) {
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        
        keyFrameAnimation.delegate = self
        // set view stay at final point when animation complete
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeForwards
        
        keyFrameAnimation.values = [
            NSValue(cgRect: mask.bounds),
            NSValue(cgRect: CGRect(x: 0, y: 0, width: 70, height: 70)),
            NSValue(cgRect: CGRect(x: 0, y: 0, width: 2500, height: 2500))]
        keyFrameAnimation.duration = 1
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 0.5
        keyFrameAnimation.keyTimes = [0, 0.4, 1]
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)]
        
        mask.add(keyFrameAnimation, forKey: "bounds")
    }
    
    // MARK:- CAAnimationDelegate Methods
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        // Remove the mask when animation completed
        self.window?.rootViewController?.view.layer.mask = nil
    }
    
    // MARK:-

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

