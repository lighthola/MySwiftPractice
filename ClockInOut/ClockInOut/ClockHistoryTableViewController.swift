//
//  ClockHistoryTableViewController.swift
//  ClockInOut
//
//  Created by Bevis Chen on 2018/5/29.
//  Copyright © 2018年 Bevis Chen. All rights reserved.
//

import UIKit

class ClockHistoryTableViewController: UITableViewController {

    let handler = ClockInOutHandler()
    var clockInfos: [(clock: Clock, isExpand: Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshClockInfos()
    }
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        refreshClockInfos()
    }
    
    func refreshClockInfos() {
        clockInfos = handler.get45DaysInfos().map{ ($0, false) }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clockInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let clock = clockInfos[indexPath.row].clock
        let isExpand = clockInfos[indexPath.row].isExpand
        let isClockIn = clock.clockIn != nil ? "✅" : "🆘"
        let isClockOut = clock.clockOut != nil ? "✅" : "🆘"
        var date = String(clock.id)
        date.insert("-", at: date.index(date.startIndex, offsetBy: 4))
        date.insert("-", at: date.index(date.startIndex, offsetBy: 7))
        
        var text = date + "    上班 " + isClockIn + "    下班 " + isClockOut
        if isExpand {
            var formatter: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                return formatter
            }
            cell.textLabel?.numberOfLines = 0
            if let clockIn = clock.clockIn {
                
                text += "\n上班：\(formatter.string(from: clockIn as Date))"
            }
            
            if let clockOut = clock.clockOut {
                text += "\n下班：\(formatter.string(from: clockOut as Date))"
            }
        } else {
            cell.textLabel?.numberOfLines = 1
        }
        cell.textLabel?.text = text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clockInfos[indexPath.row].isExpand = !clockInfos[indexPath.row].isExpand
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
