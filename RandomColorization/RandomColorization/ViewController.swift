//
//  ViewController.swift
//  RandomColorization
//
//  Created by Bevis Chen on 2016/10/21.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    // MARK:- IBOutlet
    
    
    // MARK:- Variable
    var player: AVAudioPlayer!
    var gradientLayer: RadialGradientLayer!
    var timer: Timer?
    
    // MARK:- Constant
    let audioName = "Ecstasy.mp3"
    let colors: [CGColor] =
        [UIColor.rgba(r: 10, g: 10, b: 10, a: 0.8).cgColor,
         UIColor.rgba(r: 200, g: 0, b: 0, a: 0.4).cgColor,
         UIColor.rgba(r: 0, g: 200, b: 0, a: 0.3).cgColor,
         UIColor.rgba(r: 0, g: 0, b: 200, a: 0.3).cgColor,
         UIColor.rgba(r: 10, g: 10, b: 10, a: 0.8).cgColor]
    let locations: [CGFloat] = [0.0, 0.30, 0.50, 0.70, 0.9]
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareAudioPlayer()
        prepareGraientLayer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK:- Set UI
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // For layer orientation
        prepareGraientLayer()
    }
    
    fileprivate func prepareGraientLayer() {
        
        if gradientLayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        gradientLayer = RadialGradientLayer(center: view.center, radius: 200, colors: colors, locations: locations)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK:- Set Data
    fileprivate func prepareAudioPlayer() {
        
        let url = Bundle.main.url(forResource: audioName, withExtension: nil)
        do {
            try player = AVAudioPlayer(contentsOf: url!)
            player.delegate = self
            player.isMeteringEnabled = true
            
        } catch let error {
            print("--\n Audio Error: \(error)\n--")
        }
    }
    
    // MARK:- IBAction Methods
    @IBAction func playBtnPressed(_ sender: AnyObject) {
        
        togglePlayer()
    }

    // MARK:- Private Methods
    fileprivate func togglePlayer() {
        
        timer?.invalidate()
        if !player.isPlaying {
            
            player.prepareToPlay()
            player.play()
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(changeBGColor), userInfo: nil, repeats: true)
        } else {
            
            player.stop()
        }
    }
    
    @objc fileprivate func changeBGColor() {
        
        if player.isPlaying {
            
            let power = getAudioAveragePower()
            view.backgroundColor = UIColor(colorLiteralRed: power.random0_255() / 255, green: power.random0_255() / 255, blue: power.random0_255() / 255, alpha: 1)
        }
    }

    fileprivate func getAudioAveragePower() -> Float {
        
        var averagePower: Float = 0.0
        var peakPower: Float = 0.0
        
        if player.isPlaying {
            
            player.updateMeters()
            for index in 0...player.numberOfChannels {
                averagePower += player.averagePower(forChannel: index)
                peakPower += player.peakPower(forChannel: index)
            }
            averagePower = -(averagePower / Float(player.numberOfChannels))
            peakPower = -(peakPower / Float(player.numberOfChannels))
            
            print("average: \(averagePower), peak: \(peakPower), Channels: \(player.numberOfChannels), \(player.isMeteringEnabled)" )
        }
        return averagePower
    }
    
    // MARK:- AVAudioPlayerDelegate Methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        togglePlayer()
    }
    
    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIColor {
    
    class func rgba(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
        
        let cgFloat255 = CGFloat(255)
        
        return UIColor(red: CGFloat(r) / cgFloat255, green: CGFloat(g) / cgFloat255, blue: CGFloat(b) / cgFloat255, alpha: a)
    }
}

extension Float {
    
    func random0_255() -> Float{
        return self * Float(arc4random()).remainder(dividingBy: 255.0)
    }
}
