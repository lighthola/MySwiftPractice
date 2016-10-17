//
//  PlayVideoCollectionViewCell.swift
//  PlayVideo
//
//  Created by Bevis Chen on 2016/10/14.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

struct Video {
    
    var path: String
    var thumbnail: UIImage {
        
        let sourceURL = URL(fileURLWithPath: path)
        let asset = AVAsset(url: sourceURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTimeMake(1, 1)
        let imageRef = try! imageGenerator.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage:imageRef)
        
        return thumbnail
    }
    
    var name: String {
        
        return URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
    }
    
    var duration: String {
        
        let sourceURL = URL(fileURLWithPath: path)
        let asset = AVAsset(url: sourceURL)
        let seconds = asset.duration.value / Int64(asset.duration.timescale)
        
        let second = String(seconds % 60)
        let minute = String(seconds / 60)
        let hour = String(seconds / 3600)
        
        if hour != "0" {
            return hour + ":" + minute + ":" + second
        } else {
            return minute + ":" + second
        }
    }
    
    init(path: String) {
        self.path = path
    }
}

class PlayVideoCollectionViewCell: UICollectionViewCell {
    
    // MARK:- IBOutlet
    @IBOutlet weak var screenshotImageView: UIImageView!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var videoTimeLabel: UILabel!
    
    
    // MARK:-
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("--\n PlayVideoCollectionViewCell Init Coder\n--")
    }
    
}
