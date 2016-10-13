//
//  FontShowCollectionViewCell.swift
//  CustomFont
//
//  Created by Bevis Chen on 2016/10/13.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class FontShowCollectionViewCell: UICollectionViewCell {

    // MARK:- IBOutlet
    @IBOutlet weak var textLebel: UILabel!
    
    // MARK:- Variable
    
    // MARK:-
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSLog("Cell Init Coder Execute.")
    }

}
