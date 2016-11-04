//
//  GradientTableViewCell.swift
//  AnimationTable
//
//  Created by Bevis Chen on 2016/11/3.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class GradientTableViewCell: UITableViewCell {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    private var gradientLayer = CAGradientLayer()
    var colorLevel: CGFloat = 0.0 {
        didSet {
            backgroundColor = UIColor(red: 1, green: colorLevel, blue: 0, alpha: 1)
        }
    }
    var translation: (x: CGFloat, y: CGFloat) = (0, 0) {
        didSet {
            transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            UIView.animate(withDuration: 0.5, delay: TimeInterval(colorLevel), usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {

                self.transform = CGAffineTransform.identity
            }) { isFinish in
                print(isFinish)
            }
        }
    }
    
    // MARK:- Constant
    
    
    // MARK:-
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBaseUI()
        
    }

    // MARK:- Set UI
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }

    private func setBaseUI() {
        
        textLabel?.backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor(white: 0.9, alpha: 1)
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(white: 1, alpha: 0.2).cgColor,
                                UIColor(white: 1, alpha: 0.3).cgColor,
                                UIColor.clear.cgColor,
                                UIColor(white: 0, alpha: 0.1).cgColor]
        gradientLayer.locations = [0, 0.03, 0.97, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
