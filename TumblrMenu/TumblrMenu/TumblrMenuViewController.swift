//
//  TumblrMenuViewController.swift
//  TumblrMenu
//
//  Created by Bevis Chen on 2016/11/22.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class TumblrMenuViewController: UIViewController {

    // MARK:- IBOutlet
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var quoteBtn: UIButton!
    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var audioLabel: UILabel!
    
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    let animatedTransitioningManager = CustomViewControllerAnimatedTransitioning()
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = animatedTransitioningManager
    }

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
