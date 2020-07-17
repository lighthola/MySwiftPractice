//
//  File.swift
//  ClockInOut
//
//  Created by Bevis Chen on 2018/5/29.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import Foundation
import CoreData

extension Clock {
    class var date_yyyyMMdd: String  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }
    
    class func fetch(_ predicate: NSPredicate?, _ limit: Int = 1) throws -> [Clock] {
        let request: NSFetchRequest<Clock> = Clock.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.predicate = predicate
        request.fetchLimit = limit
        return try DataModelHandler.default.moc.fetch(request)
    }
    
    class func fetchAll() throws -> [Clock] {
        return try Clock.fetch(nil, 365)
    }
    
    class func fetchToday() -> Clock? {
        guard let id = Int(Clock.date_yyyyMMdd) else { return nil }
        let predicate = NSPredicate(format: "id = %d", id)
        return try? Clock.fetch(predicate).first
    }
    
    class func fetch45() throws -> [Clock] {
        return try Clock.fetch(nil, 45)
    }
    
    class func newClock() -> Clock {
        let clock = Clock(context: DataModelHandler.default.moc)
        if let id = Int(Clock.date_yyyyMMdd) {
            clock.id = Int64(id)
        }
        return clock
    }
    
    class func clockInUpdate() {
        let todayClock = Clock.fetchToday() ?? Clock.newClock()
        todayClock.clockIn = Date() as NSDate
        DataModelHandler.default.saveContext()
    }
    
    class func clockOutUpdate() {
        let todayClock = Clock.fetchToday() ?? Clock.newClock()
        todayClock.clockOut = Date() as NSDate
        DataModelHandler.default.saveContext()
    }
    
    class func clearClockIn() {
        if let todayClock = Clock.fetchToday() {
            todayClock.clockIn = nil
            DataModelHandler.default.saveContext()
        }
    }
    
    class func clearClockOut() {
        if let todayClock = Clock.fetchToday() {
            todayClock.clockOut = nil
            DataModelHandler.default.saveContext()
        }
    }
}
