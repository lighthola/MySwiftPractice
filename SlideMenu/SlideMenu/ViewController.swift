//
//  ViewController.swift
//  SlideMenu
//
//  Created by Bevis Chen on 2016/11/15.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK:- IBOutlet
    @IBOutlet weak var hamburgerBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- Variable
    var menuVC: MenuTableViewController?
    var maskView: UIView?
    
    // MARK:- Constant
    let news:[(mainImage: String, title:String, author: String, authorImage: String)] =
        [("1","Love mountain.","Allen Wang","a"),
         ("2","New graphic design - LIVE FREE","Cole","b"),
         ("3","Summer sand","Daniel Hooper","c"),
         ("4","Seeking for signal","Noby-Wan Kenobi","d")]
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBaseUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }

    // MARK:- Set UI
    private func setBaseUI() {
        
        // return an original image, not changed to default blue btn color.
        hamburgerBtn.image? = UIImage(named: "menu")!.withRenderingMode(.alwaysOriginal)
        
        self.tableView.separatorStyle = .none
        
        setNavigationBarTranslucnet()
    }
    
    private func setNavigationBarTranslucnet() {
        
        let colorImage = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.5).image()
        let clearImage = UIColor.clear.image()
        
        self.navigationController?.navigationBar.setBackgroundImage(colorImage, for: .default)
        // clear the shadow line under navigation bar
        self.navigationController?.navigationBar.shadowImage = clearImage
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK:- IBAction Methods
    @IBAction func hamburgerBtnPressed(_ sender: Any) {
        
        if menuVC == nil {
            
            maskView = UIView(frame: self.view.frame)
            maskView?.backgroundColor = UIColor(white: 0, alpha: 0.2)
            maskView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(maskView!)
            
            menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuVC") as? MenuTableViewController
            addChildViewController(menuVC!)
            
            var frame = self.view.bounds
            frame.size.height = CGFloat(44 * menuVC!.menuItems.count) > CGFloat(UIScreen.main.bounds.height - self.navigationController!.navigationBar.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) ? CGFloat(UIScreen.main.bounds.height - self.navigationController!.navigationBar.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) : CGFloat(44 * menuVC!.menuItems.count)
            frame.origin.y = -frame.size.height + self.navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
            
            menuVC?.view.frame = frame
            self.view.addSubview(menuVC!.view)
            menuVC?.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
                
                self.view.frame.origin.y = frame.size.height
                
            }, completion: { (isFinish) in
                
            })
        } else {
            
            self.maskView?.removeFromSuperview()
            self.maskView = nil
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
                
                self.view.frame.origin.y = 0
                
            }, completion: { (isFinish) in
                
                self.menuVC?.willMove(toParentViewController: nil)
                self.menuVC?.view.removeFromSuperview()
                self.menuVC?.removeFromParentViewController()
                self.menuVC = nil
        
            })
        }
    }
    
    // MARK:- UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        
        cell.MainImageView.image = UIImage(named: news[indexPath.row].mainImage)
        cell.authorImageView.image = UIImage(named: news[indexPath.row].authorImage)
        cell.authorNameLabel.text = news[indexPath.row].author
        cell.titleLabel.text = news[indexPath.row].title
        
        return cell
    }
    
    
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIColor {
    
    func image() -> UIImage {
        
        // navigation bar + status bar
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        
        return image!
    }
}

