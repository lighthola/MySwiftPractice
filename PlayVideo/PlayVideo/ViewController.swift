//
//  ViewController.swift
//  PlayVideo
//
//  Created by Bevis Chen on 2016/10/14.
//  Copyright © 2016年 Bevis Chen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK:- IBOutlet
    @IBOutlet weak var playVideoCollectionView: UICollectionView!
    
    
    // MARK:- Variable
    var player: AVPlayer = AVPlayer()
    
    // MARK:- Constant
    let padding: (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) = (1, 0, 1, 0)
    let videoInfos: [(image: String, name: String, time: String)] =
        [("videoScreenshot01", "Super Mario", "6:30"),
         ("videoScreenshot02", "Happy Face GO GO", "5:30"),
         ("videoScreenshot03", "Night View Is Good!!", "4:30"),
         ("videoScreenshot04", "I'm Your FATHER~", "3:30"),
         ("videoScreenshot05", "PPAP", "2:30"),
         ("videoScreenshot06", "Dog Sad Life", "1:30")]
    let youtubeIDs = ["i_7ALQz9XFI",
                      "UVzRPqbOGvU",]
    
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBaseUI()
    }
    
    // MARK:- Set UI
    private func setBaseUI() {
        
        playVideoCollectionView.contentInset = UIEdgeInsetsMake(padding.top, padding.left, padding.bottom, padding.right)
    }
    
    // MARK:- Private Methods

    
    // MARK: Prepare Video Player
    private func prepareVideoPlayerNoController(cell: PlayVideoCollectionViewCell) {
        
        let path = Bundle.main.path(forResource: "emoji zone", ofType: "mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cell.bounds
        cell.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        player.play()
    }
    
    private func prepareVideoPlayerController(cell: PlayVideoCollectionViewCell) {
        
        let path = Bundle.main.path(forResource: "emoji zone", ofType: "mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.view.frame = cell.bounds
        self.addChildViewController(playerController)
        cell.addSubview(playerController.view)
        playerController.didMove(toParentViewController: self)
        playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        player.play()
    }
    
    // MARK:- UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let cell = collectionView.cellForItem(at: indexPath) as! PlayVideoCollectionViewCell
        if (player.rate == 0 || player.error != nil) {
            
//            prepareVideoPlayerNoController(cell: cell)
            prepareVideoPlayerController(cell: cell)
            
        } else {
            print("--\n Status: \(player.status)\n Rate: \(player.rate)\n Error: \(player.error)\n")
        }
    }
    
    // MARK:- UICollectionViewDataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoInfos.count + youtubeIDs.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < videoInfos.count {
            
            let reuseIdentifier = "cell1"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlayVideoCollectionViewCell
            
            if indexPath.row == 0 {
                
                let video = Video(path: Bundle.main.path(forResource: "emoji zone", ofType: "mp4")!)
                
                cell.screenshotImageView.image = video.thumbnail
                cell.videoNameLabel.text = video.name
                cell.videoTimeLabel.text = video.duration
                
            } else {
                
                cell.screenshotImageView.image = UIImage(named: videoInfos[indexPath.row].image)
                cell.videoNameLabel.text = videoInfos[indexPath.row].name
                cell.videoTimeLabel.text = videoInfos[indexPath.row].time
            }
            
            return cell
            
        } else {
            
            let reuseIdentifier = "cell2"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlayYouTubeCollectionViewCell
            cell.videoID = youtubeIDs[indexPath.row - videoInfos.count]
            
            return cell
        }
    }

    // MARK:- Other Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

