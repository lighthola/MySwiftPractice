//
//  SwipeTabItem.swift
//  SwipeView
//
//  Created by Bevis Chen on 2017/7/5.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class SwipeTabItem: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

struct SwipeTabItemData {
    var image: UIImage
    var title: String
}
