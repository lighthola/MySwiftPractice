//
//  DataModelHandler.swift
//  CoreDataMigration
//
//  Created by Bevis Chen on 2016/12/7.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import CoreData

class DataModelHandler: NSObject {

    // 1. define DB file location
    lazy private var dbFileUrl = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("database.sqlite")
    // 2. locate data model dir url
    lazy private var dataModelDirUrl: URL = {
        guard let url = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
            fatalError("var datamodelDirUrl error: nil.")
        }
        return url
    }()
    
    // 3. Is migration needed?
    private func isMigrationNeeded() -> Bool {
        
        // i. get sql file meta data
        do {
            let sMetaData = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: dbFileUrl, options: nil)
            
            return !currentModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: sMetaData)
        } catch {
            fatalError("func isMigrationNeeded error: \(error)")
        }
        
        return false
    }
    
    // 4. do migration
    private func migrate() {
        do {
            let sMetaData = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: dbFileUrl, options: nil)
            let sDataModel = NSManagedObjectModel.mergedModel(from: [Bundle.main], forStoreMetadata: sMetaData)

            let sModelVersion = Int(sDataModel!.versionIdentifiers.first!.description)!
            let dModelVersion = Int(currentModel.versionIdentifiers.first!.description)!
            
            // get data models
            let modelUrls = Bundle.main.urls(forResourcesWithExtension: "mom", subdirectory: dataModelDirUrl.lastPathComponent)!
            var dataModels: [String: NSManagedObjectModel] = [:]
            for modelUrl in modelUrls {
                let dataModel = NSManagedObjectModel(contentsOf: modelUrl)
                if let dataModelId = dataModel?.versionIdentifiers.first?.description {
                    dataModels[dataModelId] = dataModel
                }
            }
            
            // get mapping models
            let mappingUrls = Bundle.main.urls(forResourcesWithExtension: "cdm", subdirectory: nil)!
            var mappingModels: [String: NSMappingModel] = [:]
            for mappingUrl in mappingUrls {
                let mappingName = mappingUrl.lastPathComponent
                let mappingKey = "\(mappingName.components(separatedBy: ".").first!.characters.last!)"
                mappingModels[mappingKey] = NSMappingModel(contentsOf: mappingUrl)
            }
            
            // match mapping model with data model to do migrate
            for index in sModelVersion..<dModelVersion {
                
                print("migrate v.\(index) to v.\(index + 1) ...")
                
                let sDataModel = dataModels["\(index)"]
                let dDataModel = dataModels["\(index + 1)"]
                let mappingFile = mappingModels["\(index + 1)"]
                
                do {
                    let tempUrl = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("temp.sqlite")
                    let migrationManager = NSMigrationManager(sourceModel: sDataModel!, destinationModel: dDataModel!)
                    try migrationManager.migrateStore(from: dbFileUrl, sourceType: NSSQLiteStoreType, options: nil, with: mappingFile, toDestinationURL: tempUrl, destinationType: NSSQLiteStoreType, destinationOptions: nil)
                    try FileManager.default.removeItem(at: dbFileUrl)
                    try FileManager.default.copyItem(at: tempUrl, to: dbFileUrl)
                    try FileManager.default.removeItem(at: tempUrl)
                    
                    print("migrate v.\(index) to v.\(index + 1) done")
                } catch {
                    fatalError("func migrate, process error \(error)")
                }
            }
            
            print("source data model id: \(sModelVersion)")
            print("current data model id: \(dModelVersion)")
        } catch {
            fatalError("func migrate error: \(error)")
        }
    }
    
    // 5. combine final sql file and current data model
    private func load() {
        
        if persistentStore == nil {
            if !addPersistentStore() {
                abort()
            }
        }
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    // 6. core data object: PersistentStoreCoordinator, ManagedObjectModel, ManagedObjectContext, PersistentObjectStore
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.currentModel)
    lazy private var currentModel: NSManagedObjectModel = { [unowned self] in // to resolve retain cycle
        guard let model = NSManagedObjectModel(contentsOf: self.dataModelDirUrl) else {
            fatalError("var currentModel error: nil.")
        }
        return model
    }()
    private var persistentStore: NSPersistentStore!
    
    var context: NSManagedObjectContext!
    
    override init() {
        super.init()
        
        if !FileManager.default.fileExists(atPath: dbFileUrl.path) {
            addPersistentStore()
        }
        start()
    }
    
    @discardableResult
    private func addPersistentStore() -> Bool {
        do {
            persistentStore = try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbFileUrl, options:nil)
            /*// lightweight migration
             [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
             ]
            // */
            
            return true
        } catch {
            fatalError("func addPersistentStore error: \(error)")
        }
        return false
    }
    
    private func start() {
        if isMigrationNeeded() {
            migrate()
        }
        load()
    }
    
    // 7. for use
    static let shard = DataModelHandler()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("func saveContext error: \(error).")
            }
        }
    }
}
