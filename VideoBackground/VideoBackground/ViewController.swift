//
//  ViewController.swift
//  VideoBackground
//
//  Created by Bevis Chen on 2016/10/27.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    lazy var videoPlayer:AVPlayer = {
        let url = Bundle.main.url(forResource: "moments", withExtension: "mp4")
        return AVPlayer(url: url!)
        }()
    var alwaysRepeat: Bool = true {
        didSet {
            if alwaysRepeat {
                 NotificationCenter.default.addObserver(self, selector: #selector(ViewController.replayVideo) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
    
    // MARK:- Constant
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVideoOnBackground()
        alwaysRepeat = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Set UI
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setVideoOnBackground() {
    
        let videoLayer = AVPlayerLayer(player: videoPlayer)
        videoLayer.frame = view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.insertSublayer(videoLayer, at: 0)
        videoPlayer.play()
    }
    
    // MARK:- Notification Methods
    @objc fileprivate func replayVideo() {
        
        videoPlayer.seek(to: kCMTimeZero)
        videoPlayer.play()
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

