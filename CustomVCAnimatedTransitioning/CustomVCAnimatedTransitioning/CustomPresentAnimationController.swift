//
//  CustomPresentAnimationController.swift
//  CustomVCAnimatedTransitioning
//
//  Created by Bevis Chen on 2016/11/11.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    var isPresenting = true
    
    // MARK:- Constant
    
    
    // MARK:-
    
    
    // MARK:- UIViewControllerAnimatedTransitioning Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let finalFrameForVC = transitionContext.finalFrame(for: toVC)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        
        // set animate start point
        if isPresenting {
            
            toVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
            toVC.view.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1)
            containerView.addSubview(toVC.view)
        } else {
            
            fromVC.view.frame = bounds
            // rotate a little first, to make sure dismiss will rotate same side with presenting.
            fromVC.view.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI * -0.00001), 0, 0, 1)
            containerView.addSubview(toVC.view)
            containerView.addSubview(fromVC.view)
        }
    
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveLinear], animations: {
            
            if self.isPresenting {
                
                fromVC.view.alpha = 0.5
                toVC.view.frame = finalFrameForVC
                toVC.view.layer.transform = CATransform3DRotate(toVC.view.layer.transform, CGFloat(M_PI), 0, 0, 1)
            } else {
                
                fromVC.view.alpha = 0.5
                fromVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
                let transform = CATransform3DRotate(fromVC.view.layer.transform, CGFloat(M_PI * -0.99999), 0, 0, 1)
                fromVC.view.layer.transform = CATransform3DScale(transform, 0.1, 0.1, 1)
            }
        }) { (finished) in
            
            // call this to remove fromVC
            transitionContext.completeTransition(true)
            fromVC.view.alpha = 1
        }
    }
    
}
