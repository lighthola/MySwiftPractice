//
//  ViewController.swift
//  CoreDataMigration
//
//  Created by Bevis Chen on 2016/12/7.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(NSPersistentContainer.defaultDirectoryURL().path) // sqllite storage path
        print(Bundle.main.bundlePath) // data model stroage dir path
        
        /*//
        let app = UIApplication.shared.delegate as! AppDelegate
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: app.persistentContainer.viewContext)
        book.setValue("1234, An Apple A Day, Keep The Doctor Away.", forKey: "name")
        
        //book.setValue("Get a Hapy Life.", forKey: "sub_title")
        book.setValue("Steve Jobs", forKey: "author")
        
        app.saveContext()
        // */
        
//        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: DataModelHandler.shard.context)
//        book.setValue("An Apple A Day, Keep The Doctor Away.", forKey: "title")
//        book.setValue("Get a Hapy Life.", forKey: "sub_title")
//        book.setValue("Steve Jobs", forKey: "author")
        DataModelHandler.shard.saveContext()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

