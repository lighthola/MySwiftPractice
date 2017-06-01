//
//  OVOTabBarButtonItem.swift
//  CustomTabBarController
//
//  Created by Bevis Chen on 2017/5/25.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

@IBDesignable
class OVOTabBarItem: UIView {

    @IBInspectable
    var selected: UIImage? {
        didSet {
            button.setImage(selected, for: .highlighted)
            button.setImage(selected, for: .selected)
            button.setImage(selected, for: .disabled)
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var unselected: UIImage? {
        didSet {
            button.setImage(unselected, for: .normal)
            setNeedsDisplay()
        }
    }
    
    var destinationViewController: UIViewController?
    
    
    var button: UIButton!
    var performSegue:(()->())?
    var isDynamic = false
    weak var tabBarController: OVOTabBarController?
    
    override func draw(_ rect: CGRect) {
        button.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    // MARK: - Initializer
    convenience init(destination: UIViewController, tag: Int) {
        self.init(frame: .zero)
        
        initializer()
        isDynamic = true
        self.tag = tag
        destinationViewController = destination
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializer()
    }
    
    private func initializer() {
        
        let button = UIButton(type: .custom)
        self.addSubview(button)
        self.button = button
        button.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit
        
        
        /*
         https://stackoverflow.com/questions/25666269/how-to-detect-orientation-change
        */
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayout(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // MARK: -
    func updateLayout(_ notification: NSNotification? = nil) {
        setNeedsDisplay()
    }
    
    func btnAction() {
        tabBarController?.selectedIndex = self.tag
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("item deinit: \(tag)")
    }
}
