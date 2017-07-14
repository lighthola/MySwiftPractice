//
//  ViewController.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/5.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var view1: UIView! {
        didSet {
            view1.layer.borderColor = UIColor.black.cgColor
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            view1.addGestureRecognizer(tap)
        }
    }
    var isSelected = false
    
    @objc func tapAction() {
        let itemWidth = self.view1.frame.size.width
        UIView.animate(withDuration: 0.5) {
            if self.isSelected {
                //self.view1.frame.size.width = 0.5 * itemWidth
                for subView in self.view1.subviews {
                    subView.frame.origin.x =  (self.view1.frame.width / 2 - subView.bounds.width) / 2
                }
            }
            else {
                //self.view1.frame.size.width = 2 * itemWidth
                for subView in self.view1.subviews {
                    subView.frame.origin.x +=  (itemWidth * 2 - subView.bounds.width) / 2 - subView.frame.minX
                }
                self.view1.frame.size.width = 2 * itemWidth
            }
            print(self.view1.constraints)
        }
        
        
        isSelected = !isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view1.isHidden = true
        
        let swipeItem = SwipeItem(frame: CGRect(x: view.bounds.width/2 - 34, y: 300, width: 69, height: 100))
        view.addSubview(swipeItem)
        
        let item = SwipeItem(frame: .zero)
        item.size = .big
        var items = [item]
        
        for _ in 0..<4 {
            items.append(SwipeItem())
        }
        
        let swipeTabBar = SwipeTabBar(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100), items: items)
        view.addSubview(swipeTabBar)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


