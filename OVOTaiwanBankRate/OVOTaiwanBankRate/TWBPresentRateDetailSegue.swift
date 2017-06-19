//
//  PresentRateDetail.swift
//  OVOTaiwanBankRate
//
//  Created by Bevis Chen on 2017/6/12.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class TWBPresentRateDetailSegue: UIStoryboardSegue {
    
    override func perform() {
        super.perform()
        destination.view.isHidden = true
        UIView.animate(withDuration: 0.25) { 
            self.destination.view.isHidden = false
        }
    }
}
