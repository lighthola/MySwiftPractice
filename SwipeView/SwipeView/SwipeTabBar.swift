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
    var highlightView: UIView?
    var highlightViewLeadingConstraint: NSLayoutConstraint?
    var itemSize: CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width / CGFloat(items.count + 1), height: bounds.height)
    }
    
    convenience init(items: [SwipeItem]) {
        self.init()
        self.items = items
        basicInit()
    }
    
    convenience init(frame: CGRect, items: [SwipeItem]) {
        self.init(frame: frame)
        self.items = items
        basicInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't be call.")
    }
    
    private func basicInit() {
        // basic UI
        backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.262745098, blue: 0.337254902, alpha: 1)
        layoutItems()
        layoutHighLightView()
    }
    
    private func layoutHighLightView() {
        let highlightView = UIView()
        insertSubview(highlightView, at: 0)
        highlightView.translatesAutoresizingMaskIntoConstraints = false
        let hlvWidthconstraint = NSLayoutConstraint(item: highlightView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: itemSize.width * 2)
        let hlvVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[highlightView]|", options: [], metrics: nil, views: ["highlightView": highlightView])
        let hlvLeadingConstraint = NSLayoutConstraint(item: highlightView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: CGFloat(selectedItem) * itemSize.width)
        addConstraint(hlvWidthconstraint)
        addConstraints(hlvVConstraints)
        addConstraint(hlvLeadingConstraint)
        
        highlightView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.highlightView = highlightView
        highlightViewLeadingConstraint = hlvLeadingConstraint
    }
    
    private func layoutItems() {
        for (i, item) in items.enumerated() {
            item.titleLabel.alpha = 0
            
            // Setting tap action of item and animation.
            item.action = animateItemsWhenTap
            
            // Setting Constraints for items
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
                item.titleLabel.alpha = 1
                item.leftArrowImageView.alpha = 1
                item.rightArrowImageView.alpha = 1
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
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for item in items {
            if item.size == .big && CATransform3DEqualToTransform(item.imageView.layer.transform, CATransform3DIdentity) {
                item.imageView.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(1.2, 1.2, 1), 0, -0.1 * (bounds.height * 0.8 - 12), 0)
            }
        }
    }
    
    func animateItemsWhenTap(currentItem: SwipeItem) {
        // Animating item's layout when tap.
        // If it's last item setting size to .normal, new to .big
        for (i, item) in items.enumerated() {
            if item.size == .big {
                item.constraintWidth?.constant /= 2
                item.size = .normal
                item.titleLabel.alpha = 0
                item.leftArrowImageView.alpha = 0
                item.rightArrowImageView.alpha = 0
                UIView.animate(withDuration: 0.35, delay: 0.15, options: [], animations: {
                    item.imageView.layer.transform = CATransform3DIdentity
                }, completion: nil)
            }
            
            if item === currentItem {
                selectedItem = i
            }
        }
        currentItem.constraintWidth?.constant *= 2
        currentItem.size = .big
        
        highlightViewLeadingConstraint?.constant = CGFloat(selectedItem) * itemSize.width
        
        UIView.animate(withDuration: 0.35, delay: 0.15, options: [], animations: {
            currentItem.titleLabel.alpha = 1
            currentItem.leftArrowImageView.alpha = self.selectedItem != 0 ? 1 : 0
            currentItem.rightArrowImageView.alpha = self.selectedItem != self.items.count - 1 ? 1 : 0
            currentItem.imageView.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(1.2, 1.2, 1), 0, -0.1 * currentItem.imageView.bounds.height, 0)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        })
        
        // Call items action
        itemsAction(selectedItem: selectedItem)
    }
    
    func itemsAction(selectedItem: Int) {
        if let itemOnSelected = self.itemOnSelected {
            itemOnSelected(selectedItem)
        }
    }
}
