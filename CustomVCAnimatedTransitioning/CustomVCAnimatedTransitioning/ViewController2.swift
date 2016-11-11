//
//  ViewController2.swift
//  CustomVCAnimatedTransitioning
//
//  Created by Bevis Chen on 2016/11/11.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

    // MARK:- IBAction Methods
    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil);
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
