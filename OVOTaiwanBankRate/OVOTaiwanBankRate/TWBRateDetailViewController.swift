//
//  TWBRateDetail.swift
//  OVOTaiwanBankRate
//
//  Created by Bevis Chen on 2017/6/12.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit

class TWBRateDetailViewController: UIViewController {
    
    @IBOutlet weak var averagePrice: UILabel!{
        didSet{
            averagePrice.text = "0"
        }
    }
    @IBOutlet weak var totalAmount: UILabel!{
        didSet{
            totalAmount.text = "0"
        }
    }
    @IBOutlet weak var totalGains: UILabel!{
        didSet{
            totalGains.text = "0"
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.isHidden = true
            detailView.layer.cornerRadius = 10
            detailView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            detailView.layer.borderWidth = 2
        }
    }
    
    @IBOutlet weak var priceTF: UITextField! {
        didSet {
            priceTF.delegate = self
        }
    }
    @IBOutlet weak var amountTF: UITextField! {
        didSet {
            amountTF.delegate = self
        }
    }
    @IBOutlet weak var closeOutBtn: UIButton!
    
    var currency: String? {
        didSet {
            navigationItem.title = currency
        }
    }
    var rate: TWBRate?
    var historysManager: TWBRateDetailHistorysManager?
    var historys = [TWBRateDetailHistory]() {
        didSet {
            if let historysManager = self.historysManager {
                self.averagePrice.text = String(historysManager.averagePrice(of: historys))
                self.totalAmount.text = String(historysManager.totalAmount(of: historys))
                self.totalGains.text = String(historysManager.totalGains(of: historys, currentBuy: rate!.buy).rounded5())
                self.totalGains.textColor = historysManager.totalGains(of: historys, currentBuy: rate!.buy) > 0 ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.06480577257, alpha: 1) : #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historysManager = TWBRateDetailHistorysManager(key: currency!)
        historys.append(contentsOf: historysManager!.historys)
    }
    
    deinit {
        
        defer {
            UserDefaults.standard.synchronize()
        }
        
        if historys.count > 0 {
            let historysArray = NSMutableArray()
            for history in historys {
                let historyDict = NSMutableDictionary()
                historyDict["price"] = history.price
                historyDict["amount"] = history.amount
                historyDict["isCloseOut"] = history.isCloseOut
                historysArray.add(historyDict)
            }
            UserDefaults.standard.setValue(historysArray, forKey: currency!)
        }
        else {
            UserDefaults.standard.removeObject(forKey: currency!)
        }
    }
    
    @IBAction func comfirmBtnPressed(_ sender: Any) {
        
        defer {
            detailView.isHidden = true
            view.endEditing(true)
        }
        
        guard checkFormat(priceTF.text) && checkFormat(amountTF.text) else {
            return
        }
        
        let history = TWBRateDetailHistory(price: priceTF.text!, amount: amountTF.text!)
        
        if let editingIndexPath = tableView.indexPathForSelectedRow {
            historys[editingIndexPath.row].price = priceTF.text!
            historys[editingIndexPath.row].amount = amountTF.text!
        }
        else {
            historys.insert(history, at: 0)
        }
        tableView.reloadData()
    }
    
    func checkFormat(_ number:String?) -> Bool {
        
        guard let number = number else {
            return false
        }
        
        if number.isEmpty {
            return false
        }
        
        if number.contains("..") {
            return false
        }
        
        if number.characters.last == "." {
            return false
        }
        
        return true
    }

    @IBAction func closeOutBtnPressed(_ sender: Any) {
        if let editingIndexPath = tableView.indexPathForSelectedRow {
            let alert = UIAlertController(title: nil, message: "確定結清", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let comfirm = UIAlertAction(title: "確定", style: .default, handler: { (action) in
                self.historys[editingIndexPath.row].isCloseOut = true
                self.detailView.isHidden = true
                self.tableView.reloadRows(at: [editingIndexPath], with: .fade)
            })
            alert.addAction(cancel)
            alert.addAction(comfirm)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        detailView.isHidden = false
        closeOutBtn.isEnabled = false
        priceTF.becomeFirstResponder()
        priceTF.text = String(rate!.sell)
        amountTF.text = ""
    }
    @IBAction func closeOutAll(_ sender: Any) {
        if historys.count > 0 {
            let alert = UIAlertController(title: nil, message: "確定結清", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let comfirm = UIAlertAction(title: "確定", style: .default, handler: { (action) in
                
                for i in 0..<self.historys.count {
                    self.historys[i].isCloseOut = true
                    self.tableView.reloadData()
                }
            })
            alert.addAction(cancel)
            alert.addAction(comfirm)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TWBRateDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TWBRateDetailTableViewCell
        
        let price = historys[indexPath.row].price
        let amount = historys[indexPath.row].amount
        let total = Double(price)! * Double(amount)!
        let gains = Double(amount)! * Double(rate!.buy) - total
        cell.price.text = price
        cell.amount.text = amount
        cell.total.text = String(total)
        cell.gains.text = String(gains.rounded5())
        cell.gains.textColor = gains > 0 ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.06480577257, alpha: 1) : #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        cell.closeOut.isHidden = !historys[indexPath.row].isCloseOut
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            historys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension TWBRateDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        priceTF.text = historys[indexPath.row].price
        amountTF.text = historys[indexPath.row].amount
        detailView.isHidden = false
        closeOutBtn.isEnabled = !historys[indexPath.row].isCloseOut
    }
}

extension TWBRateDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard string.characters.count != 0 else {
            return true
        }
        
        do {
            var newString = (textField.text as NSString!).replacingCharacters(in: range, with: string)
            let expression = "^[0-9]+(.[0-9]{0,5})?$"
            let regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
            let numberOfMatches = regex.numberOfMatches(in: newString, options: [], range: NSRange(location: 0, length: newString.characters.count))
            if numberOfMatches == 0 {
                return false
            }
        }
        catch let error {
            print(error)
        }
        
        return true
    }
}
