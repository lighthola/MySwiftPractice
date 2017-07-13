//
//  SwipeTabBar.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/10.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class SwipeTabBar: UIView {
    
    var items: [SwipeItem] = [SwipeItem]()
    var constraintsWidth = [NSLayoutConstraint]()
    var itemOnSelected: ((Int)->())?
    var selectedItem: Int = 0
    //weak var parent: UIView?
    
    convenience init(items: [SwipeItem]) {
        self.init()
        self.items = items
        layoutItems()
    }
    
    convenience init(frame: CGRect, items: [SwipeItem]) {
        self.init(frame: frame)
        self.items = items
        layoutItems()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't be call.")
    }
    
    func layoutItems() {

        // Setting Constraints for items
        let width = UIScreen.main.bounds.width
        let itemSize = CGSize(width: width / CGFloat(items.count + 1), height: bounds.height)
        for (i, item) in items.enumerated() {
            var hVSL: String
            var views: [String: Any]
            if i == 0 {
                hVSL = "H:|[item]"
                views = ["item": item]
            }
            else {
                hVSL = "H:[leftItem][item]"
                views = ["item": item, "leftItem": items[i-1]]
            }
            
            var itemWidth = itemSize.width
            if item.size == .big {
                itemWidth *= 2
                selectedItem = i
            }
            
//            var widthMultiplier = 1 / CGFloat(items.count + 1)
//            if item.size == .big {
//                widthMultiplier *= 2
//            }
//            // Setting item width
//            item.translatesAutoresizingMaskIntoConstraints = false
//            addSubview(item)
//            let constraintW = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: parent, attribute: .width, multiplier: widthMultiplier, constant: 1)
            
            // Setting item width
            item.translatesAutoresizingMaskIntoConstraints = false
            addSubview(item)
            let constraintW = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: itemWidth)
            constraintsWidth.append(constraintW)
            item.constraintWidth = constraintW
            addConstraint(constraintW)
            
            // Setting item order.
            let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: hVSL, options: [], metrics: nil, views: views)
            let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[item]|", options: .alignAllCenterY, metrics: nil, views: ["item": item])
            addConstraints(constraintsH)
            addConstraints(constraintsV)
            
            // Setting tap action of item and animation.
            item.action = animateItemsWhenTap
            
            
            // basic UI
            backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.262745098, blue: 0.337254902, alpha: 1)
        }
    }
    
    func animateItemsWhenTap(currentItem: SwipeItem) {
        // Animating item's layout when tap.
        // If it's last item setting size to .normal, new to .big
        for item in items {
            if item.size == .big {
                item.constraintWidth?.constant /= 2
                item.size = .normal
                break
            }
        }
        currentItem.constraintWidth?.constant *= 2
        currentItem.size = .big
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        
        // Call items action
        itemsAction(currentItem: currentItem)
    }
    
    func itemsAction(currentItem: SwipeItem) {
        for (i, constraint) in constraintsWidth.enumerated() {
            if constraint === currentItem.constraintWidth {
                if let itemOnSelected = self.itemOnSelected {
                    selectedItem = i
                    itemOnSelected(i)
                }
                break
            }
        }
    }
}
