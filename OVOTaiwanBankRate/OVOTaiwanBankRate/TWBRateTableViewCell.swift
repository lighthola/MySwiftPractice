//
//  TWBRateTableViewCell.swift
//  OVOTaiwanBankRate
//
//  Created by Bevis Chen on 2017/6/12.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class TWBRateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var buy: UILabel!
    @IBOutlet weak var sell: UILabel!
    @IBOutlet weak var gains: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
