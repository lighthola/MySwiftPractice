//
//  ViewController.swift
//  CustomTabBarController
//
//  Created by Bevis Chen on 2017/5/24.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addItem(_ sender: Any) {
        guard let parent = parent as? OVOTabBarController else {
            fatalError("parent view controller not found.")
        }
        
        //weak var weakParent = parent
        
        let newVC = UIViewController()
        newVC.view.backgroundColor = .blue
        let label = UILabel()
        label.text = "ViewController\(parent.tabBarItems.last!.tag + 2)"
        label.font = UIFont.systemFont(ofSize: 32)
        
        OVOLayoutConstraint.centerIn(newVC.view, attached: label)
        
        let new1 = OVOTabBarItem(destination: newVC, tag: parent.tabBarItems.last!.tag + 1)
        new1.selected = UIImage(named: "icon1_selected")
        new1.unselected = UIImage(named: "icon1_unselected")
        parent.tabBarItems.append(new1)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        guard let parent = parent as? OVOTabBarController else {
            fatalError("parent view controller not found.")
        }
        
        parent.removeTabBarItem(at: parent.tabBarItems.count - 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

