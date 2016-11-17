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
    @IBOutlet weak var hamburgerBtn: UIBarButtonItem! {
        didSet{
            let btn = UIButton(type: .system)
            btn.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
            
            // return an original image, not changed to default blue btn color.
            btn.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
            btn.addTarget(self, action: #selector(hamburgerBtnPressed(_:)), for: .touchUpInside)
            hamburgerBtn.customView = btn
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Variable
    var menuVC: MenuTableViewController?
    var maskView: UIView?
    var menuFrame: CGRect {
        
        // get frame by navigation bar and status bar
        var frame = self.view.bounds
        frame.size.height = CGFloat(44 * menuVC!.menuItems.count) > CGFloat(UIScreen.main.bounds.height - self.navigationController!.navigationBar.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) ? CGFloat(UIScreen.main.bounds.height - self.navigationController!.navigationBar.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) : CGFloat(44 * menuVC!.menuItems.count)
        frame.origin.y = -frame.size.height + self.navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
        
        return frame
    }
    var isOrientation = false
    
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
        
        // notification after orientation did change
        NotificationCenter.default.addObserver(self, selector:#selector(setSlideMenuForOrientation(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    // MARK:- Set UI
    private func setBaseUI() {
        
        self.tableView.separatorStyle = .none
        
        setNavigationBarTranslucnet()
    }
    
    private func setNavigationBarTranslucnet() {
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        // get image for background
        let colorImage = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.5).image()
        self.navigationController?.navigationBar.setBackgroundImage(colorImage, for: .default)
        
        // clear the shadow line under navigation bar
        let clearImage = UIColor.clear.image()
        self.navigationController?.navigationBar.shadowImage = clearImage
    }
    
    func setSlideMenuForOrientation(_ notification: Notification) {
    
        // if actual orientation to change frame of menu
        if menuVC != nil && self.isOrientation == true {
            self.menuVC?.view.frame.size.height = menuFrame.size.height
            self.menuVC?.view.frame.origin.y = self.navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
            self.tableView.contentOffset.y -= self.menuVC!.view.frame.size.height
            self.isOrientation = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // flag for actual orientation
        self.isOrientation = true
    }
    
    // MARK:- IBAction Methods
    @IBAction func hamburgerBtnPressed(_ sender: Any) {
        
        // disable hamburger untill animation finished
        let btn = self.hamburgerBtn.customView as! UIButton
        btn.isEnabled = false
        
        // show menu
        if menuVC == nil {
            
            // hierarchy of ViewController
            //          menu
            //            |
            //         maskView
            //            |
            //        self.view
            
            maskView = UIView(frame: self.tableView.frame)
            maskView?.backgroundColor = UIColor(white: 0, alpha: 0.2)
            maskView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(maskView!)
            
            // creating a container view that is added on parent view
            menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuVC") as? MenuTableViewController
            addChildViewController(menuVC!)
            menuVC?.view.frame = menuFrame
            self.view.addSubview(menuVC!.view)
            menuVC?.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                
                self.menuVC?.view.frame.origin.y = self.navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
                self.tableView.contentOffset.y -= self.menuVC!.view.frame.size.height
                
                self.hamburgerBtn.customView?.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI * 0.5), 0, 0, 1)
                
            }, completion: { (isFinish) in

                btn.isEnabled = true
            })
            
        // hide menu
        } else {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                
                self.menuVC?.view.frame.origin.y = -self.menuVC!.view.frame.size.height + self.navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
                self.tableView.contentOffset.y += self.menuVC!.view.frame.size.height
                
                self.hamburgerBtn.customView?.layer.transform = CATransform3DIdentity
                
            }, completion: { (isFinish) in
                
                // remove container view from superview
                self.menuVC?.willMove(toParentViewController: nil)
                self.menuVC?.view.removeFromSuperview()
                self.menuVC?.removeFromParentViewController()
                self.menuVC = nil
                
                self.maskView?.removeFromSuperview()
                self.maskView = nil
                
                btn.isEnabled = true
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
    
    // get color image for navigation bar background
    func image() -> UIImage {

        // height = navigation bar + status bar
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

