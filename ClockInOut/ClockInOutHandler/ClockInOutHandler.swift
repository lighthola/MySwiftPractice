//
//  ClockInOutHandler.swift
//  ClockInOut
//
//  Created by Bevis Chen on 2018/5/29.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import Foundation

protocol ClockInOutProtocol {
    var isClockIn: Bool { get }
    var isClockOut: Bool { get }
    
    func clockIn()
    func clockOut()
}

class ClockInOutHandler: ClockInOutProtocol {
    
    private var todayClock: Clock? {
        return Clock.fetchToday()
    }
   
    var isClockIn: Bool {
        guard let todayClock = todayClock else { return false }
        return todayClock.clockIn != nil
    }
    
    var isClockOut: Bool {
        guard let todayClock = todayClock else { return false }
        return todayClock.clockOut != nil
    }
    
    var clockInTime: String? {
        guard let todayClock = todayClock else { return nil }
        return isClockIn ? formatter.string(from: todayClock.clockIn! as Date) : nil
    }
    
    var clockOutTime: String? {
        guard let todayClock = todayClock else { return nil }
        return isClockOut ? formatter.string(from: todayClock.clockOut! as Date) : nil
    }
    
    func clockIn() {
        Clock.clockInUpdate()
    }
    
    func clockOut() {
        Clock.clockOutUpdate()
    }
    
    func deleteClockIn() {
        Clock.clearClockIn()
    }
    
    func deleteClockOut() {
        Clock.clearClockOut()
    }
    
    func get45DaysInfos() -> [Clock] {
        do {
            return try Clock.fetch45()
        } catch  {
            print(error.localizedDescription)
        }
        return []
    }
}

extension ClockInOutHandler {
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter
    }
    
}

