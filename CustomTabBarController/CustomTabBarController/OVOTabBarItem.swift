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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
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
    
    weak var button: UIButton!
    var performSegue:(()->())?
    var isDynamic = false
    
    
    override func draw(_ rect: CGRect) {
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.center = CGPoint(x: frame.width/2, y: frame.height/2)
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayout(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // MARK: -
    func updateLayout(_ notification: NSNotification? = nil) {
        setNeedsDisplay()
    }
    
    func btnAction() {
        performSegue?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("item deinit: \(tag)")
    }
}
