//
//  NewCell.swift
//  AppleNewsApp
//
//  Created by Bevis Chen on 2017/6/26.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var provider: UILabel!
    @IBOutlet weak var title: UILabel!
}

struct News {
    let image: String
    let provider: String
    let title: String
    let cellType: NewsCellType
}

enum NewsCellType: String {
    case big = "cell_big"
    case horizontal = "cell_h"
    case vertical = "cell_v"
}
