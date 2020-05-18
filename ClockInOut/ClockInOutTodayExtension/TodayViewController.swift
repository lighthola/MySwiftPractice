//
//  TodayViewController.swift
//  ClockInOutTodayExtension
//
//  Created by Bevis Chen on 2018/5/30.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var clockInBtn: UIButton!
    @IBOutlet weak var clockInTimeLabel: UILabel!
    @IBOutlet weak var clockOutBtn: UIButton!
    @IBOutlet weak var clockOutTimeLabel: UILabel!
    
    let handler = ClockInOutHandler()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clockInBtn.layer.cornerRadius = 5
        clockOutBtn.layer.cornerRadius = 5
        
        refreshUI()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        refreshUI()
        completionHandler(NCUpdateResult.newData)
    }
    
    func refreshUI() {
        let isClockIn = handler.isClockIn
        clockInBtn.isEnabled = !isClockIn
        clockInTimeLabel.text = isClockIn ? handler.clockInTime : "尚未打卡"
        clockInBtn.isHidden = isClockIn
        
        let isClockOut = handler.isClockOut
        clockOutBtn.isEnabled = !isClockOut
        clockOutTimeLabel.text = isClockOut ? handler.clockOutTime : "尚未打卡"
        clockOutBtn.isHidden = isClockOut
    }
    
    @IBAction func clockInBtnPressed(_ sender: Any) {
        handler.clockIn()
        refreshUI()
    }
    
    @IBAction func clockOutBtnPressed(_ sender: Any) {
        handler.clockOut()
        refreshUI()
    }
    
}
