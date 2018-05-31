//
//  Clock+CoreDataProperties.swift
//  ClockInOut
//
//  Created by Bevis Chen on 2018/5/29.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//
//

import Foundation
import CoreData


extension Clock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Clock> {
        return NSFetchRequest<Clock>(entityName: "Clock")
    }

    @NSManaged public var id: Int64
    @NSManaged public var clockIn: NSDate?
    @NSManaged public var clockOut: NSDate?

}
