 //
//  ViewController.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Arthur Knopper on 28/12/2016.
//  Copyright © 2016 Arthur Knopper. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UITextFieldDelegate {
    
    var pasteBoard = UIPasteboard.general
    var tableData = ["dog","cat","fish"]
    
    @IBOutlet weak var strokeLabel: StrokeLabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func toggle(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        log.obj(tableView)/
        log.any(action)/
        log.ln("\(indexPath)")/
        log.any(sender!)/
        
        if (action == #selector(UIResponderStandardEditActions.copy(_:))) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let cell = tableView.cellForRow(at: indexPath)
        pasteBoard.string = cell!.textLabel?.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}
 extension RandomAccessCollection {
    func random() -> Iterator.Element? {
        guard count > 0 else { return nil }
        let offset = arc4random_uniform(numericCast(count))
        let i = index(startIndex, offsetBy: numericCast(offset))
        return self[i]
    }
 }
 
 
// Returns `URL` with guided fail
public enum SocketEndPoint: String {
    case eventSocket = "http://nowhere.com/events"
    case liveSocket = "http://nowhere.com/live"
    
    public var url: URL {
        guard let url = URL(string: self.rawValue) else {
            fatalError("Unconstructable URL: \(self.rawValue)")
        }
        return url
    }
}
 
// Uses normal initializer
public struct WebSocket {
    public let url: URL
    public init(url: URL) {
        self.url = url
    }
}
 

