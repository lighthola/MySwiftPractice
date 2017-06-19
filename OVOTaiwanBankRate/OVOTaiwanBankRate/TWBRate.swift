//
//  TWBRate.swift
//  OVOTaiwanBankRate
//
//  Created by Bevis Chen on 2017/6/12.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit
import Alamofire

struct TWBRate {
    var currency: String
    var buy: Double = 0.0
    var sell: Double = 0.0
}

class TWBRateNetwork {
    
    private let baseSite = "http://rate.bot.com.tw/"
    private let multiCountry = "xrt/flcsv/0/day"
    
    func get(_ multiCountryRates:@escaping (_ rates:[TWBRate])->()) {
        Alamofire.request(baseSite + multiCountry).response { (response) in
            //print(response)
            //print(response.data!)
            
            guard response.error == nil else {
                fatalError("StatusCode:\(String(describing: response.response?.statusCode))\nError:\(response.error!.localizedDescription)")
            }
            
            guard let data = response.data else {
                fatalError("download failed.")
            }
            
            guard let context = String(data: data, encoding: String.Encoding.utf8) else {
                fatalError("data convert to string failed.")
            }
            //print(context)
            
            let lines = context.components(separatedBy: "\n")
            //print(lines)
            
            var rates = [TWBRate]()
            for (i, line) in lines.enumerated() {
                guard i > 0 else {
                    continue
                }
                let cells = line.components(separatedBy: ",")
                if cells.count > 13 {
                    //print("\(cells[0]) \(cells[3]) \(cells[13])")
                    if Double(cells[3]) ?? 0 > 0 {
                        let buy  = Double(cells[3]) ?? 0
                        let sell = Double(cells[13]) ?? 0
                        let rate = TWBRate(currency: cells[0], buy: buy, sell: sell)
                        rates.append(rate)
                    }
                }
            }
            
            
            multiCountryRates(rates)
        }
    }
}
