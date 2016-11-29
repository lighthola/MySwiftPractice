//
//  PhotoCollectionViewCell.swift
//  CollectionViewAnimation
//
//  Created by Bevis Chen on 2016/11/29.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK:- IBOutlet
    @IBOutlet weak var phptoImageView: UIImageView!
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.isHidden = true
        }
    }
    
    
    // MARK:- Variable
    var backBtnAction: (() -> Void)?
    var selectedFrame: CGRect {
        
        var frame = self.superview!.bounds
        frame.origin.y += 20
        return frame
    }


    // MARK:- Constant
        
    // MARK:-
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 10
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        guard let action = backBtnAction  else {
            print("backBtnAction is NIL")
            return
        }
        
        action()
    }
}
