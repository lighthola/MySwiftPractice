//
//  ViewController.swift
//  imageScale
//
//  Created by Bevis Chen on 2016/10/26.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    // MARK:- IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK:- Variable
    
    
    // MARK:- Constant
    
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGradientBackground()
        
        print(imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setImageMaxScale()
        print(imageView)
    }
    
    // MARK:- Set UI
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    fileprivate func setGradientBackground() {
        
        let bgLayer = CAGradientLayer()
        bgLayer.frame = view.bounds
        bgLayer.colors = [UIColor.cyan.cgColor, UIColor.brown.cgColor, UIColor.magenta.cgColor, UIColor.purple.cgColor, UIColor.white.cgColor]
        bgLayer.locations = [0.0, 0.25, 0.5, 0.75, 1]
        bgLayer.startPoint = CGPoint.zero // left top
        bgLayer.endPoint = CGPoint(x: 1, y: 1) // right bottom
        self.view.layer.insertSublayer(bgLayer, at: 0)
    }
    
    fileprivate func setImageMaxScale() {
        
        let viewSize = imageView.bounds.size
        let imageSize = imageView.image!.size
        
        guard imageSize.width > viewSize.width || imageSize.height > viewSize.height else {
            // Image too small
            return
        }
        
        if imageSize.width >= imageSize.height {
            scrollView.maximumZoomScale = imageSize.width / viewSize.width
        } else {
            scrollView.maximumZoomScale = imageSize.height / viewSize.height
        }
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        setScrollViewContentInset()
    }
    
    fileprivate func setScrollViewContentInset() {
        
        let viewSize = (
            frame: imageView.frame.size,
            bounds: imageView.bounds.size
        )
        // The Size of image Aspect Fit
        let imageRealSize = AVMakeRect(aspectRatio: imageView.image!.size, insideRect: imageView.frame).size
        let vPadding = -(viewSize.frame.height - fmax(imageRealSize.height, viewSize.bounds.height)) / 2
        let hPadding = -(viewSize.frame.width - fmax(imageRealSize.width, viewSize.bounds.width)) / 2
        
        scrollView.contentInset = UIEdgeInsetsMake(vPadding, hPadding, vPadding, hPadding)
    }
}

