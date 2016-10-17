//
//  PlayYouTubeCollectionViewCell.swift
//  PlayVideo
//
//  Created by Bevis Chen on 2016/10/17.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayYouTubeCollectionViewCell: UICollectionViewCell {
    
    // MARK:- IBOutlet
    @IBOutlet weak var youTubePlayerView: YTPlayerView!
    
    // MARK:- Variable
    var videoID: String = "" {
        
        didSet {
            youTubePlayerView.load(withVideoId: videoID)
        }
    }
    
    // MARK:- Constant
    
    
    // MARK:-
}
