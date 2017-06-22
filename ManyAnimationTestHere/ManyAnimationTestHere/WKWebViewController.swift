//
//  WKWebViewController.swift
//  IOS10ContextMenuTableViewTutorial
//
//  Created by Bevis Chen on 2017/4/20.
//  Copyright © 2017年 Arthur Knopper. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {

    
    fileprivate var webView = WKWebView()
    fileprivate var isFinishLoad = false
    
    var newNaviBar: UIView = UIView()
    var newNaviLabel: UILabel = UILabel()
    
    fileprivate var isNeedToChangeStatusBar = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    enum StatusBarStatus {
        case none
        case hidden
        case display
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = view.bounds
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(URLRequest(url: URL(string: "https://www.apple.com/")!))
        
        webView.scrollView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        webView.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        //-------
        
        
        newNaviBar = UIView(frame: (self.navigationController?.navigationBar.bounds)!)
        newNaviBar.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
        newNaviLabel = UILabel(frame: newNaviBar.bounds)
        newNaviLabel.text = "New Web"
        newNaviLabel.textAlignment = .center
        newNaviBar.addSubview(newNaviLabel)
        self.navigationController?.navigationBar.addSubview(newNaviBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
               
        let view2 = UIView(frame: CGRect(x: 394, y: 716, width: 10, height: 10))
        view2.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.view.addSubview(view2)
        

        guard let naviBar = self.navigationController?.navigationBar else {
            return;
        }
        
        guard let naviTitle = self.navigationController?.navigationBar.subviews[1].subviews.first else {
            return;
        }
        
        
        
        
//        let oldFrame = naviTitle.frame
//        naviTitle.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
//        naviTitle.frame = oldFrame
//        
//        let naviBarOldFrame = naviBar.frame
//        naviBar.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
//        naviBar.frame = naviBarOldFrame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return isNeedToChangeStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}

// MARK: UIScrollViewDelegate
extension WKWebViewController: UIScrollViewDelegate
{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation: \(scrollView.contentOffset)")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         print("scrollViewWillBeginDragging: \(scrollView.contentOffset)")
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging: \(scrollView.contentOffset)")
        
        //print("navigationController: \(self.navigationController!.navigationBar)")
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating: \(scrollView.contentOffset)")
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll: \(scrollView.contentOffset)")
        
        guard let navi = self.navigationController else {
            return;
        }
        
        let naviBar  = navi.navigationBar
        
        print(scrollView.contentInset)
        
        // When web view finish load
        if isFinishLoad {
            
            if scrollView.contentOffset.y >= -20 {
                
                guard naviBar.layer.affineTransform() == CGAffineTransform.identity else {
                    return;
                }
                
                UIView.animate(withDuration: 0.25, animations: {

                    // navi bar move up
                    naviBar.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: -24))
                    // 貼在 navi bar 上面的 view 中的 label
                    // because navi bar move up, so label label need move down.
                    self.newNaviLabel.transform = CGAffineTransform(translationX: 0, y: 12).scaledBy(x: 0.75, y: 0.75)
                    // hide status bar
                    self.isNeedToChangeStatusBar = true
                })
            }
            else {
                
                guard naviBar.layer.affineTransform() != CGAffineTransform.identity else {
                    return;
                }
                
                UIView.animate(withDuration: 0.25, animations: {
                    //naviTitle.center.y -= 12
                    naviBar.layer.setAffineTransform(CGAffineTransform.identity)
                    self.newNaviLabel.transform = CGAffineTransform.identity
                    
                    self.isNeedToChangeStatusBar = false
                })
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop: \(scrollView.contentOffset)")
        
    }
}

extension WKWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        //isFinishLoad = false
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webViewDidFinish:%@",webView.scrollView.contentSize)
        
        isFinishLoad = true
        //webView.scrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: false)
        
        
    }
}

extension WKWebViewController: WKUIDelegate {
    
}


