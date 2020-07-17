//
//  ViewController.swift
//  ClockIn&Out
//
//  Created by Bevis Chen on 2018/5/28.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var clockInBtn: UIButton!
    @IBOutlet weak var clockInTimeLabel: UILabel!
    @IBOutlet weak var clockOutBtn: UIButton!
    @IBOutlet weak var clockOutTimeLabel: UILabel!
    
    let handler = ClockInOutHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUI), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Observe Core Data remote change notifications.
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).storeRemoteChange(_:)),
            name: .NSPersistentStoreRemoteChange, object: DataModelHandler.default.persistentContainer.persistentStoreCoordinator)
    }
    
    @objc
    func storeRemoteChange(_ notification: Notification) {
        print("✅###\(#function): Merging changes from the other persistent store coordinator.")
        DispatchQueue.main.async {
            self.refreshUI()
        }
    }
    
    @IBAction func clockInBtnPressed(_ sender: Any) {
        handler.clockIn()
        refreshUI()
    }
    
    @IBAction func clockOutBtnPressed(_ sender: Any) {
        handler.clockOut()
        refreshUI()
    }
    
    @IBAction func logBtnPressed(_ sender: Any) {
        do {
            let clockInfos =
                try Clock.fetchAll()
            
            for info in clockInfos {
                print(info.id)
                print(info.clockIn?.timeIntervalSince1970 ?? 0)
                print(info.clockOut?.timeIntervalSince1970 ?? 0)
                print("---")
            }
        } catch {
            fatalError("\(error)")
        }
        
    }
    
    @objc
    func refreshUI() {
        let isClockIn = handler.isClockIn
        clockInBtn.isEnabled = !isClockIn
        clockInTimeLabel.text = isClockIn ? handler.clockInTime : nil
        
        let isClockOut = handler.isClockOut
        clockOutBtn.isEnabled = !isClockOut
        clockOutTimeLabel.text = isClockOut ? handler.clockOutTime : nil
    }
    
    @IBOutlet weak var deleteTodayClockInBtn: UIButton! {
        didSet {
            deleteTodayClockInBtn.isHidden = true
        }
    }
    @IBOutlet weak var deleteTodayClockOutBtn: UIButton! {
        didSet {
            deleteTodayClockOutBtn.isHidden = true
        }
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        deleteTodayClockInBtn.isHidden = !deleteTodayClockInBtn.isHidden
        deleteTodayClockOutBtn.isHidden = !deleteTodayClockOutBtn.isHidden
    }
    
    @IBAction func deleteTodayClockInBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "⚠️", message: "你將刪除今日 上班 打卡資料", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "確定", style: .default) {  [unowned self] (_) in
            self.handler.deleteClockIn()
            self.editBtnPressed(sender)
            self.refreshUI()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { [unowned self] (_) in
            self.editBtnPressed(sender)
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteTodayClockOutBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "⚠️", message: "你將刪除今日 下班 打卡資料", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "確定", style: .default) {  [unowned self] (_) in
            self.handler.deleteClockOut()
            self.editBtnPressed(sender)
            self.refreshUI()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { [unowned self] (_) in
            self.editBtnPressed(sender)
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

