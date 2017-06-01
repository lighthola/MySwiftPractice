//
//  MyTabBarItemSegue.swift
//  CustomTabBarController
//
//  Created by Bevis Chen on 2017/5/24.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class OVOTabBarControllerSegue: UIStoryboardSegue {

    override func perform() {
        guard let identifier = self.identifier else {
            fatalError("Segue identifier not found.")
        }
        
        guard let tag = Int(identifier) else {
            fatalError("Segue identifier is not an Integer.")
        }
        
        guard let tabBarController = source as? OVOTabBarController else {
            fatalError("Source ViewController is not MyTabBarController.")
        }
        
        guard let transitionView = tabBarController.transitionView else {
            fatalError("tabBarController.transitionView not found.")
        }
        
        defer {
            //print("child VC:\(tabBarController.childViewControllers.count)")
            //print("transition subviews:\(transitionView.subviews.count)")
        }
                
        if tabBarController.attachedViewTags.contains(tag) {
            for attachedView in transitionView.subviews {
                if attachedView.tag == tag {
                    transitionView.bringSubview(toFront: attachedView)
                    animateTransition(last: tabBarController.lastAttachedView, new: attachedView)
                    
                    tabBarController.lastAttachedView = attachedView
                }
            }
        }
        /*
          Initializing the attached View
        */
        else {
            destination.view.tag = tag
            tabBarController.attachedViewTags.append(tag)
            
            animateTransition(last: tabBarController.lastAttachedView, new: destination.view)

            tabBarController.lastAttachedView = destination.view
            
            OVOLayoutConstraint.sameSizeWith(transitionView, attached:  destination.view)
            
            tabBarController.addChildViewController(destination)
            destination.didMove(toParentViewController: tabBarController)
        }
    }
    
    func animateTransition(last: UIView?, new: UIView?) {
        
        if let new = new, let last = last {
            let size = new.bounds.size
            let transform = new.transform
            
            let x = new.tag > last.tag ? size.width : -size.width
            
            new.transform = transform.translatedBy(x: x, y: 0)
            //new.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                last.transform = transform.translatedBy(x: -x, y: 0)
                new.transform = .identity
            }) { (finished) in
                //print("tranition: \(finished)")
                last.transform = .identity
                //last.isHidden = true
            }
        }
    }
}
