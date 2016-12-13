//
//  DataModel2To3.swift
//  CoreDataMigration
//
//  Created by Bevis Chen on 2016/12/7.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import CoreData

class DataModel2To3: NSEntityMigrationPolicy {

    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        let dInstance = NSEntityDescription.insertNewObject(forEntityName: mapping.destinationEntityName!, into: manager.destinationContext)
        
        for key in sInstance.entity.attributesByName.keys {
            if dInstance.entity.attributesByName.keys.contains(key) {
                dInstance.setValue(sInstance.value(forKey: key), forKey: key)
            }
            
        }
        
        if let mainTitle = sInstance.value(forKey: "main_title") as? String, let subTitle = sInstance.value(forKey: "sub_title") as? String! {
            
            if subTitle != nil {
                dInstance.setValue("\(mainTitle) - \(subTitle!)", forKey: "name")
            } else {
                dInstance.setValue(mainTitle, forKey: "name")
            }
        }
        
        manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
    }
}
