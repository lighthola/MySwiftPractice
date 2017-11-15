//
//  ViewController.swift
//  TheTransOverdue
//
//  Created by Bevis Chen on 2017/11/9.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class TOCell: UITableViewCell {
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var trainType: UILabel!
    @IBOutlet weak var trainNumber: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var delayTime: UILabel!
    
    var endStationName: String? {
        didSet {
            if endStationName != nil {
                destination.text = "終點站：\(endStationName!)"
            }
        }
    }
    
    var trainClassificationID: String? {
        didSet {
            if trainClassificationID != nil {
                trainType.text = "\(trainClassificationID!)"
            }
        }
    }
    
    var trainNo: String? {
        didSet {
            if trainNo != nil {
                trainNumber.text = "\(trainNo!)"
            }
        }
    }

    var departureTimeValue: String? {
        didSet {
            if let time = departureTimeValue {
                let timeComponents = time.components(separatedBy: ":")
                
                departureTime.text = "出發時間：\(timeComponents[0]):\(timeComponents[1])"
            }
        }
    }
    
    var delayTimeValue: Int? {
        didSet {
            if delayTimeValue != nil {
                if delayTimeValue! != 0  {
                    delayTime.text = "約晚 \(delayTimeValue!)分"
                } else {
                    delayTime.text = ""
                }
                
            }
        }
    }
}

class ViewController: UIViewController {

    var isMorning: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12 :
            return true
        case 12..<23 :
            return false
        default:
            return false
        }
    }
    
    weak var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            tableView.addSubview(refreshControl)
            self.refreshControl = refreshControl
        }
    }
    
    let stationList: [(stationNo: String, twName: String, enName: String)] = StationListHandler().list
    let trainDirection = ["北上", "南下"]
    
    @IBOutlet weak var workPickerView: UIPickerView!
    @IBOutlet weak var offWorkPickerView: UIPickerView!
    
    var liveBoard = [RailLiveBoard]() {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var workStation: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "workStation")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "workStation")
        }
    }
    
    var offWorkStation: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "offWorkStation")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "offWorkStation")
        }
    }
    
    var workTrainDirection: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "workTrainDirection")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "workTrainDirection")
        }
    }
    
    var offWorkTrainDirection: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "offWorkTrainDirection")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "offWorkTrainDirection")
        }
    }
    
    @IBOutlet weak var settingViewTop: NSLayoutConstraint!
    @IBOutlet weak var searchPickerView: UIPickerView!
    
    var searchStation: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "searchStation")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "searchStation")
        }
    }
    
    var searchTrainDirection: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "searchTrainDirection")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "searchTrainDirection")
        }
    }
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workPickerView.selectRow(workStation, inComponent: 0, animated: false)
        workPickerView.selectRow(workTrainDirection, inComponent: 1, animated: false)
        offWorkPickerView.selectRow(offWorkStation, inComponent: 0, animated: false)
        offWorkPickerView.selectRow(offWorkTrainDirection, inComponent: 1, animated: false)
        searchPickerView.selectRow(searchStation, inComponent: 0, animated: false)
        searchPickerView.selectRow(searchTrainDirection, inComponent: 1, animated: false)
        
        settingViewTop.constant = -200

        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func refresh() {
        
        var title = ""
        title += isMorning ? stationList[workStation].twName : stationList[offWorkStation].twName
        title += isMorning ? trainDirection[workTrainDirection] : trainDirection[offWorkTrainDirection]
        navigationItem.title = title
        refreshModel()
    }
    
    
    func refreshModel() {
        let stationNo = isMorning ? stationList[workStation].stationNo : stationList[offWorkStation].stationNo
        let direction = isMorning ? String(workTrainDirection) : String(offWorkTrainDirection)
        apiGetRailLiveBoard(stationNo: stationNo, direction: direction)
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        if settingViewTop.constant == 0 {
            workStation = workPickerView.selectedRow(inComponent: 0)
            offWorkStation = offWorkPickerView.selectedRow(inComponent: 0)
            workTrainDirection = workPickerView.selectedRow(inComponent: 1)
            offWorkTrainDirection = offWorkPickerView.selectedRow(inComponent: 1)
            UIView.animate(withDuration: 0.25, animations: {
                self.settingViewTop.constant = -200
                self.view.layoutIfNeeded()
            }) { (_) in
                self.indicatorView.startAnimating()
                self.refresh()
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.settingViewTop.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }

    @IBAction func searchBtnPressed(_ sender: Any) {
        searchStation = searchPickerView.selectedRow(inComponent: 0)
        searchTrainDirection = searchPickerView.selectedRow(inComponent: 1)
        let stationNo = stationList[searchStation].stationNo
        let direction = String(searchTrainDirection)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.settingViewTop.constant = -200
            self.view.layoutIfNeeded()
        }) { (_) in
            
            self.navigationItem.title = "立即查 " +  self.stationList[self.searchStation].twName +  self.trainDirection[self.searchTrainDirection]
            self.indicatorView.startAnimating()
            self.apiGetRailLiveBoard(stationNo: stationNo, direction: direction)
        }
    }
    
}

extension ViewController {
    func apiGetRailLiveBoard(stationNo: String, direction: String) {
        API().getRailLiveBoard(id: stationNo, direction: direction, complection: { [unowned self] (liveBoard) in
            self.liveBoard = liveBoard
            self.refreshControl?.endRefreshing()
            self.indicatorView.stopAnimating()
        }) { [unowned self] (errorMsg) in
            let alert = UIAlertController(title: "錯誤", message: errorMsg, preferredStyle: .alert)
            let confirm = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
            self.refreshControl?.endRefreshing()
            self.indicatorView.stopAnimating()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveBoard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TOCell
        let info                   = liveBoard[indexPath.row]
        cell.endStationName        = info.endingStationName.tw
        cell.trainClassificationID = info.trainClassificationID.description
        cell.trainNo               = info.trainNo
        cell.departureTimeValue    = info.scheduledDepartureTime
        cell.delayTimeValue        = info.delayTime
        return cell
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return stationList.count
        case 1:
            return 2
        default:
            return 0
        }
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var title: String
        switch component {
        case 0:
            title = stationList[row].twName
        case 1:
            title = trainDirection[row]
        default:
            title = "Error"
        }
        
        if let label = view as? UILabel {
            label.text = title
            return label
        } else {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.text = title
            return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var msg: String
        if pickerView == workPickerView {
            msg = "上班："
        } else {
            msg = "下班："
        }
        
        switch component {
        case 0:
            print(msg + stationList[row].twName)
        case 1:
            print(msg + trainDirection[row])
        default:
            break
        }
        print("")
    }
}

