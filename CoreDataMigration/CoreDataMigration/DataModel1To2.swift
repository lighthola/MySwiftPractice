//
//  DataModel1To2.swift
//  CoreDataMigration
//
//  Created by Bevis Chen on 2016/12/7.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import CoreData

class DataModel1To2: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        let dInstance = NSEntityDescription.insertNewObject(forEntityName: mapping.destinationEntityName!, into: manager.destinationContext)
        
        if let sTitle = sInstance.value(forKey: "title") as? String {
            let titles = sTitle.components(separatedBy: ", ")
            if titles.count >= 2 {
                dInstance.setValue(titles[0], forKey: "main_title")
                dInstance.setValue(titles[1], forKey: "sub_title")
            } else {
                dInstance.setValue(sTitle, forKey: "main_title")
            }
        }
        
        dInstance.setValue("unkwon", forKey: "author")
        
        manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
    }
}
