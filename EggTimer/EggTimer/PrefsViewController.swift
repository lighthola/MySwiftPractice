//
//  prefsViewController.swift
//  EggTimer
//
//  Created by Bevis Chen on 2017/10/31.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {
    
    @IBOutlet weak var presetTitleLabel: NSTextField!
    @IBOutlet weak var presetPopUp: NSPopUpButton!
    @IBOutlet weak var sliderTitleLabel: NSTextField!
    @IBOutlet weak var sliderMinutesLabel: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var cancelBtn: NSButton!
    @IBOutlet weak var okBtn: NSButton!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showExistingPrefs()
    }
    
    @IBAction func popUpChanged(_ sender: NSPopUpButton) {
        if sender.selectedItem?.title == "Custom" {
            slider.isEnabled = true
            return
        }
        
        let newTimerDuration = sender.selectedTag()
        slider.integerValue = newTimerDuration
        showSliderValueAsText()
        slider.isEnabled = false
    }
    
    @IBAction func sliderChanged(_ sender: NSSlider) {
        showSliderValueAsText()
    }
    
    @IBAction func okBtnPressed(_ sender: Any) {
        saveNewPrefs()
        view.window?.close()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        view.window?.close()
    }
    
    func showExistingPrefs() {
        let selectedTimeInMinutes = Int(prefs.selectedTime) / 60
        
        presetPopUp.selectItem(withTitle: "Custom")
        slider.isEnabled = true
        
        for item in presetPopUp.itemArray {
            if item.tag == selectedTimeInMinutes {
                presetPopUp.select(item)
                slider.isEnabled = false
                break
            }
        }

        slider.integerValue = selectedTimeInMinutes
        showSliderValueAsText()
    }
    
    func showSliderValueAsText() {
        let newTimerDuration = slider.integerValue
        let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
        sliderMinutesLabel.stringValue = "\(newTimerDuration) \(minutesDescription)"
    }
    
    func saveNewPrefs() {
        prefs.selectedTime = slider.doubleValue * 60
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"),
                                        object: nil)
    }
}
