//
//  MenuTableViewController.swift
//  SlideMenu
//
//  Created by Bevis Chen on 2016/11/15.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    let menuItems = ["Everyday Moments", "Popular", "Editors", "Upcoming", "Fresh", "Stock-photos", "Trending"]
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        
    }
    
    // MARK:- UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        cell.titleLabel.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // change parent navi bar title when cell select
        let vc = self.parent as! ViewController
        vc.title = menuItems[indexPath.row]
        vc.hamburgerBtnPressed("")
    }

    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
