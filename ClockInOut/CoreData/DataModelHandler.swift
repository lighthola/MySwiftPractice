//
//  DataHandler.swift
//  ClockIn&Out
//
//  Created by Bevis Chen on 2018/5/28.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import Foundation
import CoreData

class DataModelHandler {
    
    let dbName = "ClockInOut"
    
    // MARK: - Core Data stack
    
    static let `default` = DataModelHandler()
    
    lazy var moc = self.persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Migrate to App Group if needed
        migratePersistentStoreToAppGroup()
        
        // Create a container that can load CloudKit-backed stores
        let container = NSPersistentCloudKitContainer(name: dbName)
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.url = appGroupPersistentStoreURL
        
        // Enable history tracking and remote notifications
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes.
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Move the store to the path of App Group

extension DataModelHandler {
    
    var appGroupID: String {
        return "group.swp.test01"
    }
    
    var oldPersistentStoreURL: URL {
        return userAppSupportDirectory.appendingPathComponent(dbName + ".sqlite")
    }
    
    var userAppSupportDirectory: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    }
    
    var appGroupPersistentStoreURL: URL {
        return appGroupDirectory.appendingPathComponent(dbName + ".sqlite")
    }
    
    var appGroupDirectory: URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!
    }
    
    /**
     Inspired by: coredata - move to app group target
     https://stackoverflow.com/questions/27253566/coredata-move-to-app-group-target#47551887
     */
    func migratePersistentStoreToAppGroup() {
        let oldStoreUrl = oldPersistentStoreURL
        let newStoreUrl = appGroupPersistentStoreURL
        var isNeedMigrate = false
        var isNeedDeleteOld = false
        
        if FileManager.default.fileExists(atPath: oldStoreUrl.path) {
            isNeedMigrate = true
            isNeedDeleteOld = true
        }
        
        if FileManager.default.fileExists(atPath: newStoreUrl.path) {
            isNeedMigrate = false
        }
        
        if isNeedMigrate {
            DBHelper.copyDocument(form: oldStoreUrl, to: newStoreUrl)
            let shmUrl = userAppSupportDirectory.appendingPathComponent(dbName + ".sqlite-shm")
            let newShmUrl = appGroupDirectory.appendingPathComponent(dbName + ".sqlite-shm")
            DBHelper.copyDocument(form: shmUrl, to: newShmUrl)
            let walUrl = userAppSupportDirectory.appendingPathComponent(dbName + ".sqlite-wal")
            let newWalUrl = appGroupDirectory.appendingPathComponent(dbName + ".sqlite-wal")
            DBHelper.copyDocument(form: walUrl, to: newWalUrl)
        }
        
        if isNeedDeleteOld {
            DBHelper.deleteDocument(at: oldStoreUrl)
            let shmDocumentUrl = userAppSupportDirectory.appendingPathComponent(dbName + ".sqlite-shm")
            DBHelper.deleteDocument(at: shmDocumentUrl)
            let walDocumentUrl = userAppSupportDirectory.appendingPathComponent(dbName + ".sqlite-wal")
            DBHelper.deleteDocument(at: walDocumentUrl)
        }
    }
}

