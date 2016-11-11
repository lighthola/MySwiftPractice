//
//  ViewController.swift
//  CustomVCAnimatedTransitioning
//
//  Created by Bevis Chen on 2016/11/11.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(segue.identifier!)
        if segue.identifier == "go" {
            
            let toVC = segue.destination as! ViewController2
            toVC.transitioningDelegate = self
        }
        
    }
    
    // MARK:- UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomPresentAnimationController()
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

