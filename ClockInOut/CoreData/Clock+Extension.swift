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
    
    class func fetchToday() throws -> Clock? {
        if let id = Int(Clock.date_yyyyMMdd) {
            let predicate = NSPredicate(format: "id = %d", id)
            return try Clock.fetch(predicate).first
        }
        return nil
    }
    
    class func fetch45() throws -> [Clock] {
        return try Clock.fetch(nil, 45)
    }
    
    class func insertClock() {
        let clock = Clock(context: DataModelHandler.default.moc)
        if let id = Int(Clock.date_yyyyMMdd) {
            clock.id = Int64(id)
        }
        clock.clockIn = Date() as NSDate
        DataModelHandler.default.saveContext()
    }
    
    class func clockInUpdate() throws {
        if let todayClock = try Clock.fetchToday() {
            todayClock.clockIn = Date() as NSDate
            DataModelHandler.default.saveContext()
        } else {
            Clock.insertClock()
        }
    }
    
    class func clockOutUpdate() throws {
        if let todayClock = try Clock.fetchToday() {
            todayClock.clockOut = Date() as NSDate
            DataModelHandler.default.saveContext()
        } else {
            Clock.insertClock()
        }
    }
    
    class func clearClockIn() throws {
        if let todayClock = try Clock.fetchToday() {
            todayClock.clockIn = nil
            DataModelHandler.default.saveContext()
        } else {
            Clock.insertClock()
        }
    }
    
    class func clearClockOut() throws {
        if let todayClock = try Clock.fetchToday() {
            todayClock.clockOut = nil
            DataModelHandler.default.saveContext()
        } else {
            Clock.insertClock()
        }
    }
}
