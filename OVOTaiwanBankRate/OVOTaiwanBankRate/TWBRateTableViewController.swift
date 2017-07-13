//
//  ViewController.swift
//  OVOTaiwanBankRate
//
//  Created by Bevis Chen on 2017/6/12.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class TWBRateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
        }
    }
    
    var rates = [TWBRate]() {
        didSet {
            //print(rates)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let rate = TWBRateNetwork()
        rate.get() { rates in
            self.rates = rates
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController.hidd
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let detail = segue.destination as! TWBRateDetailViewController
            detail.currency = rates[indexPath.row].currency
            detail.rate = rates[indexPath.row]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TWBRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TWBRateTableViewCell
        cell.currency.text = rates[indexPath.row].currency
        cell.buy.text  = String(rates[indexPath.row].buy)
        cell.sell.text = String(rates[indexPath.row].sell)
        
        let historysManager = TWBRateDetailHistorysManager(key: rates[indexPath.row].currency)
        if historysManager.historys.count > 0 {
            let totalGains = historysManager.totalGains(of: historysManager.historys, currentBuy: rates[indexPath.row].buy)
            cell.gains.text = String(totalGains.rounded5())
            cell.gains.textColor = totalGains > 0 ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.06480577257, alpha: 1) : #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        else {
            cell.gains.text = ""
        }
        return cell
    }
}

extension TWBRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension Double {
    func rounded5() -> Double {
        let divisor = pow(10.0, 5.0)
        return (self * divisor).rounded() / divisor
    }
}

