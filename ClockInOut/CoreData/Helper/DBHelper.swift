//
//  DBHelper.swift
//  ClockInOut
//
//  Created by Bevis Chen on 2018/5/30.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import Foundation

class DBHelper {
    /*
     Please note the reason why NSFileCoordinator is used to delete the file is because
     NSFileCoordinator allows us to ensure that file related tasks such as opening reading
     writing are done in such a way that wont interfere with anyother task on the system
     trying to work with the same file.Eg if you want to open a file and at the same time
     it gets deleted ,you dont want both the actions to happen at the same time.
    */
    static func deleteDocument(at url: URL){
        let fileCoordinator = NSFileCoordinator(filePresenter: nil)
        fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: {
            (urlForModifying) -> Void in
            do {
                try FileManager.default.removeItem(at: urlForModifying)
            }catch let error {
                print("Failed to remove item with error: \(error.localizedDescription)")
            }
        })
    }
    
    static func copyDocument(form oldURL: URL, to newURL: URL) {
        do {
            try FileManager.default.copyItem(at: oldURL, to: newURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
