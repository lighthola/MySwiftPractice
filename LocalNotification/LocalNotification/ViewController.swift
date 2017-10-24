//
//  ViewController.swift
//  LocalNotification
//
//  Created by Bevis Chen on 2017/10/3.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
 
    @IBAction func testBtnPressed(_ sender: Any) {
        if let lc = UserDefaults.standard.string(forKey: "lc") {
            let alertC = UIAlertController(title: "本地通知", message: lc, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alertC.addAction(cancel)
            self.present(alertC, animated: true, completion: nil)
            UserDefaults.standard.removeObject(forKey: "lc")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func lnBtnPressed(_ sender: Any) {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "title：測試本地通知"
            content.subtitle = "subtitle：法蘭克"
            content.body = "body：法蘭克的IOS世界"
            content.badge = 1
            content.sound = UNNotificationSound.default()
            
            // Image
            let imageURL: URL = Bundle.main.url(forResource: "kit-icon", withExtension: "jpg")!
            let attachment = try! UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
            content.attachments = [attachment]
            
            // 設置點擊通知後取得的資訊
            content.userInfo = ["link" : "https://www.facebook.com/franksIosApp/"]
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("成功建立通知...")
            })
        } else {
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) {
                notification.alertTitle = "title：測試本地通知title：測試本地通知title：測試本地通知title：測試本地通知title：測試本地通知"
            }
            notification.alertBody = "body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界body：法蘭克的IOS世界"
            // 設置點擊通知後取得的資訊
            notification.userInfo = ["link" : "https://www.facebook.com/franksIosApp/", "points": 25]
            notification.fireDate = Date(timeIntervalSinceNow: 0.25)
            UIApplication.shared.scheduleLocalNotification(notification)
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

