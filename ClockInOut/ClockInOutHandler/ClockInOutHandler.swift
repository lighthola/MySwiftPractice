//
//  ClockInOutHandler.swift
//  ClockInOut
//
//  Created by Bevis Chen on 2018/5/29.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import Foundation

protocol ClockInOutProtocol {
    var today: String { get }
    var isClockIn: Bool { get }
    var isClockOut: Bool { get }
    
    func clockIn()
    func clockOut()
}

class ClockInOutHandler: ClockInOutProtocol {
   
    var isClockIn: Bool {
        do {
            if let todayClock = try Clock.fetchToday() {
                return todayClock.clockIn != nil
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    var isClockOut: Bool {
        do {
            if let todayClock = try Clock.fetchToday() {
                return todayClock.clockOut != nil
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    var clockInTime: String? {
        if self.isClockIn {
            do {
                if let clockInTime = try Clock.fetchToday()?.clockIn {
                    return formatter.string(from: clockInTime as Date)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    var clockOutTime: String? {
        if self.isClockOut {
            do {
                if let clockOutTime = try Clock.fetchToday()?.clockOut {
                    return formatter.string(from: clockOutTime as Date)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    var today: String {
       return Clock.date_yyyyMMdd
    }
    
    func clockIn() {
        try? Clock.clockInUpdate()
    }
    
    func clockOut() {
        try? Clock.clockOutUpdate()
    }
    
    func deleteClockIn() {
        try? Clock.clearClockIn()
    }
    
    func deleteClockOut() {
        try? Clock.clearClockOut()
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

