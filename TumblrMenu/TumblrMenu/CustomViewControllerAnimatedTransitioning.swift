//
//  CustomViewControllerAnimatedTransitioning.swift
//  TumblrMenu
//
//  Created by Bevis Chen on 2016/11/22.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class CustomViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK:- Variable
    fileprivate var isPresenting = true
    
    // MARK:- Constant
    
    
    // MARK:-

    // MARK: UIViewController Animated Transitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let containerView = transitionContext.containerView
        
        let menuVC = isPresenting ? toVC as! TumblrMenuViewController : fromVC as! TumblrMenuViewController
        
        // Set menuVC button to out of view for animation.
        if isPresenting {
            outOf(menuVC)
        }
        
        containerView.addSubview(menuVC.view)
        
        // Animate Transition
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseIn], animations: {
            
            if self.isPresenting {
                
                self.insideOf(menuVC)
                
            } else {
                
                self.outOf(menuVC)
                
            }
            
        }) { (isFinish) in
            
            transitionContext.completeTransition(true)
            
        }
        
    }
    
    // MARK:- Animation Methods
    func outOf(_ menuVC: TumblrMenuViewController) {
        
        menuVC.view.alpha = 0
        
        let topRowOffset  : CGFloat = 300
        let middleRowOffset : CGFloat = 150
        let bottomRowOffset  : CGFloat = 50
        
        menuVC.textBtn.transform = CGAffineTransform(translationX: -topRowOffset, y: 0)
        menuVC.textLabel.transform = CGAffineTransform(translationX: -topRowOffset, y: 0)
        
        menuVC.photoBtn.transform = CGAffineTransform(translationX: topRowOffset, y: 0)
        menuVC.photoLabel.transform = CGAffineTransform(translationX: topRowOffset, y: 0)
        
        menuVC.quoteBtn.transform = CGAffineTransform(translationX: -middleRowOffset, y: 0)
        menuVC.quoteLabel.transform = CGAffineTransform(translationX: -middleRowOffset, y: 0)
        
        menuVC.linkBtn.transform = CGAffineTransform(translationX: middleRowOffset, y: 0)
        menuVC.linkLabel.transform = CGAffineTransform(translationX: middleRowOffset, y: 0)
        
        menuVC.chatBtn.transform = CGAffineTransform(translationX: -bottomRowOffset, y: 0)
        menuVC.chatLabel.transform = CGAffineTransform(translationX: -bottomRowOffset, y: 0)
        
        menuVC.audioBtn.transform = CGAffineTransform(translationX: bottomRowOffset, y: 0)
        menuVC.audioLabel.transform = CGAffineTransform(translationX: bottomRowOffset, y: 0)
        
    }
    
    func insideOf(_ menuVC: TumblrMenuViewController) {
        
        menuVC.view.alpha = 1
        
        menuVC.textBtn.transform = CGAffineTransform.identity
        menuVC.textLabel.transform = CGAffineTransform.identity
        menuVC.quoteBtn.transform = CGAffineTransform.identity
        menuVC.quoteLabel.transform = CGAffineTransform.identity
        menuVC.chatBtn.transform = CGAffineTransform.identity
        menuVC.chatLabel.transform = CGAffineTransform.identity
        menuVC.photoBtn.transform = CGAffineTransform.identity
        menuVC.photoLabel.transform = CGAffineTransform.identity
        menuVC.linkBtn.transform = CGAffineTransform.identity
        menuVC.linkLabel.transform = CGAffineTransform.identity
        menuVC.audioBtn.transform = CGAffineTransform.identity
        menuVC.audioLabel.transform = CGAffineTransform.identity
    }
}

// MARK:- UIViewController Transitioning Delegate
extension CustomViewControllerAnimatedTransitioning : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
     
        isPresenting = false
        
        return self
    }
}
