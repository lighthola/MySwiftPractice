//
//  ViewController.swift
//  AnimationTable
//
//  Created by Bevis Chen on 2016/11/3.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    let texts = ["Read 3 article on Medium", "Cleanup bedroom", "Go for a run", "Hit the gym", "Build another swift project", "Movement training", "Fix the layout problem of a client project", "Write the experience of #30daysSwift", "Inbox Zero", "Booking the ticket to Chengdu", "Test the Adobe Project Comet", "Hop on a call to mom"]
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK:- Set UI
    
    
    // MARK:- UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GradientTableViewCell
        
        cell.textLabel?.text = texts[indexPath.row]
        cell.colorLevel = CGFloat(indexPath.row) / CGFloat(texts.count) * 0.6
        cell.translation = (0, tableView.frame.size.height)
        
        return cell
    }
    
    // MARK:- UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        dismiss(animated: true) {
            print("dismiss")
        }
    }
    
    // Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

