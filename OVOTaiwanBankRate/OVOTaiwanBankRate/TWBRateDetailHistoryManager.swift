//
//  TWBRateDetailHistoryManager.swift
//  OVOTaiwanBankRate
//
//  Created by Bevis Chen on 2017/6/14.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

struct TWBRateDetailHistory {
    var price: String
    var amount: String
    var isCloseOut: Bool = false
    
    init(price: String, amount: String, isCloseOut: Bool = false) {
        self.price = price
        self.amount = amount
        self.isCloseOut = isCloseOut
    }
}

class TWBRateDetailHistorysManager {

    var key: String
    
    init(key: String) {
        self.key = key
    }
    
    var historys:[TWBRateDetailHistory] {
        var historys = [TWBRateDetailHistory]()
        if let historyArray = UserDefaults.standard.object(forKey: self.key) as? Array<Dictionary<String, Any>> {
            for historyDict in historyArray {
                if
                    let price = historyDict["price"] as? String,
                    let amount = historyDict["amount"] as? String,
                    let isCloseOut = historyDict["isCloseOut"] as? Bool {
                    let history = TWBRateDetailHistory(price: price, amount: amount, isCloseOut: isCloseOut)
                    historys.append(history)
                }
            }
        }
        return historys
    }
    
    func totalAmount(of historys: [TWBRateDetailHistory]) -> Double {
        var totalAmount = 0.0
        for history in historys {
            if !history.isCloseOut {
                totalAmount += Double(history.amount)!
            }
        }
        return totalAmount
    }
    
    func averagePrice(of historys: [TWBRateDetailHistory]) -> Double {
        var averagePrice = 0.0
        for history in historys {
            if !history.isCloseOut {
                averagePrice += Double(history.price)! * (Double(history.amount)! / totalAmount(of: historys))
            }
        }
        return averagePrice
    }
    
    func totalPrice(of historys: [TWBRateDetailHistory]) -> Double {
        return totalAmount(of: historys) * averagePrice(of: historys)
    }
    
    func totalGains(of historys: [TWBRateDetailHistory], currentBuy:Double) -> Double {
        return totalAmount(of: historys) * currentBuy - totalPrice(of: historys)
    }
}
