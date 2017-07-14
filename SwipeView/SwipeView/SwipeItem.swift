//
//  SwipeItem.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/10.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

enum SwipeItemSize {
    case normal
    case big
}

class SwipeItem: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: StrokeLabel!
    @IBOutlet weak var leftArrowImageView: UIImageView! {
        didSet {
            leftArrowImageView.alpha = 0
            leftArrowImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    @IBOutlet weak var rightArrowImageView: UIImageView! {
        didSet {
            rightArrowImageView.alpha = 0
        }
    }
    
    
    weak var constraintWidth: NSLayoutConstraint?
    
    var size: SwipeItemSize = .normal
    var action: ((SwipeItem)->())?
    
    convenience init(image: UIImage, title: String, isBig: Bool = false) {
        self.init(frame: .zero, image: image, title: title, isBig: isBig)
    }
    
    convenience init(frame: CGRect, image: UIImage, title: String, isBig: Bool = false) {
        
        var temp = frame
        temp.size.width *= 2
        self.init(frame: temp)
        
        imageView.image = image
        titleLabel.text = title
        
        if isBig {
            size = .big
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    lazy var tap: UITapGestureRecognizer = {
       return UITapGestureRecognizer(target: self, action: #selector(tapAction))
    }()
    
    func baseInit() {
        
        if let view = Bundle.main.loadNibNamed(String(describing: SwipeItem.self), owner: self, options: nil)?.last as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
        
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        
        backgroundColor = UIColor.clear
    }
    
    @objc func tapAction() {
        if let action = self.action {
            action(self)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(rect: titleLabel.bounds)
        titleLabel.layer.shadowPath = path.cgPath
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.2
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 6)
        titleLabel.layer.shadowRadius = 0
    }
}

extension CGPoint: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: StringLiteralType) {
        self.init()
        
        var point: CGPoint
        if value.first == "{"  && value.last == "}" {
            point = CGPointFromString(value)
        }
        else {
            point = CGPointFromString("{\(value)}")
        }
        
        x = point.x
        y = point.y
    }
}
