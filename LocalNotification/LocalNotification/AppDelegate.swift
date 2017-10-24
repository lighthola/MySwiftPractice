//
//  AppDelegate.swift
//  LocalNotification
//
//  Created by Bevis Chen on 2017/10/3.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
            UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { (granted, error) in
                if granted {
                    print("允許")
                } else {
                    print("不允許")
                }
            })
            UNUserNotificationCenter.current().delegate = self
        } else {
            let notificationTypes: UIUserNotificationType = [.badge, .alert, .sound]
            let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
        }
        
        
        
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
        print("在前景收到通知...")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content: UNNotificationContent = response.notification.request.content
        
        completionHandler()
        
        // 取出userInfo的link並開啟Facebook
        let requestUrl = URL(string: content.userInfo["link"]! as! String)
        UIApplication.shared.open(requestUrl!, options: [:], completionHandler: nil)
    }
    
    //
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let appState = application.applicationState
        if appState == .inactive {
            print("inactive")
            UserDefaults.standard.set("inactive", forKey: "lc")
        } else if appState == .active {
            print("active")
            UserDefaults.standard.set("active", forKey: "lc")
            if #available(iOS 10, *) { } else {
                
                let _ = InAppNotificationView.show(message: notification.alertBody!, tapAction: {
                    print("tap")
                    let requestUrl = URL(string: notification.userInfo!["link"]! as! String)
                    UIApplication.shared.openURL(requestUrl!)
                })
            }
        } else {
            print("background")
            UserDefaults.standard.set("background", forKey: "lc")
        }
        UserDefaults.standard.synchronize()
        
        
        
        print("收到本地通知...")
    }
    var number = 0

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

