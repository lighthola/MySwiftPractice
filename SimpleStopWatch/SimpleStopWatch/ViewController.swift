//
//  ViewController.swift
//  SimpleStopWatch
//
//  Created by Bevis Chen on 2016/10/12.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordTextView: UITextView!
    
// MARK: - Global Variable
    var timer:Timer = Timer()
    var time = 0.0
    var recordTimes = 0
    
// MARK: Constant
    let timeChangeFrequency = 0.01
    
// MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        setBaseUI()
    }
    
    deinit {
        
        timer.invalidate()
    }

// MARK: - Set UI
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setBaseUI() {
        timeLabel.text = String(0)
        recordTextView.text = ""
    }
    
// MARK: - IBAction Methods
    @IBAction func startBtnPressed(_ sender: AnyObject) {
        
        if !timer.isValid {
            
            timer = Timer(timeInterval: timeChangeFrequency, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        }
    }

    @IBAction func recordBtnPressed(_ sender: AnyObject) {
        
        if timer.isValid {
            
            recordTimes += 1
            recordTextView.text = recordTextView.text + "\(recordTimes). " +  timeLabel.text! + "\n"
            
            if recordTextView.contentSize.height > recordTextView.bounds.size.height {
                recordTextView.setContentOffset(CGPoint(x: 0, y: recordTextView.contentSize.height - recordTextView.bounds.size.height), animated: true)
            }
        }
    }

    @IBAction func stopBtnPressed(_ sender: AnyObject) {
        
        timer.invalidate()
    }

    @IBAction func resetBtnPressed(_ sender: AnyObject) {
        
        timer.invalidate()
        time = 0.0
        timeLabel.text = String(0)
        recordTimes = 0
        recordTextView.text = ""
    }
    
// MARK - Private Methods
    @objc private func updateTime() {
        
        time += timeChangeFrequency
        timeLabel.text = String(format: "%.2f", time)
    }
    
// MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

