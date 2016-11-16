//
//  NewsTableViewCell.swift
//  SlideMenu
//
//  Created by Bevis Chen on 2016/11/15.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK:- IBOutlet
    @IBOutlet weak var MainImageView: UIImageView!
    @IBOutlet weak var authorImageView: UIImageView! {
        didSet {
            authorImageView.layer.cornerRadius = authorImageView.bounds.size.width * 0.5
            authorImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    
    
    // MARK:-

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
