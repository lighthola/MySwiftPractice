//
//  TWBRateDetailTableViewCell.swift
//  OVOTaiwanBankRate
//
//  Created by Bevis Chen on 2017/6/13.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class TWBRateDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var gains: UILabel!
    @IBOutlet weak var closeOut: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
