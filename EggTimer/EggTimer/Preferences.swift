//
//  Preferences.swift
//  EggTimer
//
//  Created by Bevis Chen on 2017/11/1.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import Foundation

struct Preferences {
    var selectedTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            }
            return 360
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
        }
    }
}
