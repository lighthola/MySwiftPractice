//
//  NextViewController.swift
//  VideoBackground
//
//  Created by Bevis Chen on 2016/10/28.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    lazy var aString: String = {
        
        print("--")
        print("a String init ...")
        print("--")
        
        return "call aString"
    }()
    
    
    // MARK:- Constant
    
    
    // MARK:-
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK:- IBAction Methods
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnAPressed(_ sender: Any) {
        
        print(aString)
    }

    @IBAction func btnBPressed(_ sender: Any) {
        
        print(aString)
    }

    @IBAction func btnCPressed(_ sender: Any) {
        
        print(aString)
        aString = "aString is Changed"
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
