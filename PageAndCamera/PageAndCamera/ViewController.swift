//
//  ViewController.swift
//  PageAndCamera
//
//  Created by Bevis Chen on 2016/10/18.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    // MARK:- IBOutlet
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK:- Variable
    var pageDone: CGFloat {
        // Compute CGFloat remainder
        return scrollView.bounds.origin.x.truncatingRemainder(dividingBy: scrollView.bounds.size.width)
    }
    var prePage = 0
    var pageNumber: Int {
        return Int(scrollView.bounds.origin.x / scrollView.bounds.size.width)
    }
    var items: [UIBarButtonItem] {
        
        var customItems = [UIBarButtonItem]()
        
        for item in toolBar.items! {
            if item.image != nil {
                customItems.append(item)
            }
        }
        return customItems
    }
    
    // MARK:- Constant
    let icons: [(normal: String, selected: String)] =
        [("Chicken", "Chicken Filled"),
         ("Screenshot", "Screenshot Filled"),
         ("Full of Shit", "Full of Shit Filled")]
    
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK:- Set UI
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK:- Private Methods
    private func enable(page: Int) {
        
        if self.pageNumber != page {
            
            UIView.animate(withDuration: 0.3) {
                
                self.itemChangeImage(page, prePage: self.pageNumber)
                self.scrollView.bounds.origin.x = CGFloat(page) * self.scrollView.bounds.size.width
            }
        } else {
            
            itemChangeImage(page, prePage: prePage)
        }
        
    }
    
    private func itemChangeImage(_ page: Int, prePage: Int) {
        
        self.items[prePage].image = UIImage(named: self.icons[prePage].normal)
        self.items[page].image = UIImage(named: self.icons[page].selected)
    }
    
    // MARK:- IBAction Methods
    @IBAction func leftToolBarBtnPressed(_ sender: AnyObject) {
        
        enable(page: sender.tag)
    }
    
    @IBAction func centerToolBarBtnPressed(_ sender: AnyObject) {
     
        enable(page: sender.tag)
    }

    @IBAction func rightToolBarBtnPressed(_ sender: AnyObject) {
        
        enable(page: sender.tag)
    }

    // MARK:- UIScrollViewDelegate Methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if pageDone == 0.0 {
            prePage = pageNumber
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if pageDone == 0.0 {
            print("--\n Scroll View Frame: \(scrollView.frame) \n Scroll View Bounds: \(scrollView.bounds) \n Page: \(pageNumber) \n--")
            enable(page: pageNumber)
        }
    }
    
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

