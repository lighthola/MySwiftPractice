//
//  MyTabBarViewController.swift
//  CustomTabBarController
//
//  Created by Bevis Chen on 2017/5/24.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class OVOTabBarController: UIViewController {
    
    @IBOutlet weak var transitionView: UIView! {
        didSet {
            _ = swipes
        }
    }
    @IBOutlet var tabBarItems: [OVOTabBarItem]! {
        didSet {
            tabBarItems.sort {$0.tag < $1.tag}
            
            if let stack = tabBarItems.first?.superview {
                /*
                 https://stackoverflow.com/questions/30728062/add-views-in-uistackview-programmatically
                 */
                (stack as? UIStackView)?.addArrangedSubview(tabBarItems.last!)
            }
            
            for tabBarItem in tabBarItems {
                print("item tag:\(tabBarItem.tag)")
                tabBarItem.tabBarController = self
                tabBarItem.performSegue = { [weak tabBarItem] in
                    if tabBarItem?.isDynamic == true, let destination = tabBarItem?.destinationViewController {
                        let segue = OVOTabBarControllerSegue(identifier: String(tabBarItem!.tag), source: self, destination: destination)
                        self.prepare(for: segue, sender: tabBarItem?.button)
                        segue.perform()
                    }
                    else {
                        self.performSegue(withIdentifier: String(tabBarItem!.tag), sender: tabBarItem?.button)
                    }
                }
                tabBarItem.updateLayout()
            }

            print("items count: \(tabBarItems.count)")
        }
    }
    
    weak var lastAttachedView: UIView? {
        willSet(newAttachedView) {
            if lastAttachedView != nil {
                tabBarItems[lastAttachedView!.tag].button.isEnabled = true
            }
            if newAttachedView != nil {
                tabBarItems[newAttachedView!.tag].button.isEnabled = false
            }
        }
    }
    var attachedViewTags = [Int]() {
        didSet {
            attachedViewTags.sort()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            tabBarItems[selectedIndex].performSegue?()
            view.setNeedsDisplay()
        }
    }
    
    lazy var swipes: [OVOGestureRecognizer] = {
        let directions: [UISwipeGestureRecognizerDirection] = [.left, .right]
        var _swipes = [OVOGestureRecognizer]()
        
        for direction in directions {
            let swipe = OVOGestureRecognizer(view: self.transitionView, type: .Swipe) { (gesture) in
                guard gesture.state == .ended else {
                    return
                }
                
                let gesture = gesture as! UISwipeGestureRecognizer
                switch gesture.direction {
                case UISwipeGestureRecognizerDirection.left:
                    if self.selectedIndex < self.tabBarItems.count - 1 {
                        self.selectedIndex += 1
                    }
                case UISwipeGestureRecognizerDirection.right:
                    if self.selectedIndex > 0 {
                        self.selectedIndex -= 1
                    }
                default:
                    break
                }
            }
            (swipe.gesture as! UISwipeGestureRecognizer).direction = direction
            _swipes.append(swipe)
        }
        return _swipes
    }()
    
    func removeTabBarItem(at index: Int) {
        
        /*
         https://stackoverflow.com/questions/28727845/find-an-object-in-array
        */
        guard let index = tabBarItems.index(where: {$0.tag == index}) else {
            print("Out of range")
            return
        }
        
        for (i, childVC) in childViewControllers.enumerated() {
            if childVC.view.tag == tabBarItems[index].tag {
                childVC.willMove(toParentViewController: nil)
                childVC.view.removeFromSuperview()
                childVC.removeFromParentViewController()
                attachedViewTags.remove(at: i)
                break
            }
        }
        
        if let stack = tabBarItems[index].superview as? UIStackView {
            stack.removeArrangedSubview(tabBarItems[index])
            tabBarItems[index].removeFromSuperview()
        }
        
        tabBarItems.remove(at: index)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 0

        //print(tabBarItems)
        
        let newVC = UIViewController()
        newVC.view.backgroundColor = .blue
        let label = UILabel()
        label.text = "ViewController\(tabBarItems.last!.tag + 2)"
        label.font = UIFont.systemFont(ofSize: 32)
        
        OVOLayoutConstraint.centerIn(newVC.view, attached: label)
        
        let new1 = OVOTabBarItem(destination: newVC, tag: tabBarItems.last!.tag + 1)
        new1.selected = UIImage(named: "knife_s")
        new1.unselected = UIImage(named: "knife_uns")
        tabBarItems.append(new1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //print(segue)
    }

}
