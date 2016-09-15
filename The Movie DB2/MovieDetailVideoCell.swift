//
//  MovieDetailVideoCell.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/15/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AlamofireImage
class MovieDetailVideoCell:UICollectionViewCell{
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var thumbnailImageView:UIImageView!
    @IBOutlet weak var videoContainerView:UIView!
    var youTubeKey:String?{
        didSet{
            self.youTubeVideoPlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: youTubeKey!)
            self.youTubeVideoPlayer.moviePlayer.controlStyle = .None
        }
    }
    var youTubeVideoPlayer:XCDYouTubeVideoPlayerViewController!
    
    override func awakeFromNib() {
       
        let defaultCentar = NSNotificationCenter.defaultCenter()
        defaultCentar.addObserver(self, selector: #selector(videoPlayerViewControllerDidReceiveVideo(_:)), name: XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification, object: self.youTubeVideoPlayer)
        defaultCentar.addObserver(self, selector: #selector(doneButtonTapped(_:)), name: MPMoviePlayerPlaybackDidFinishNotification, object: self.youTubeVideoPlayer)
       
    }
    func doneButtonTapped(notification:NSNotification){
        
        let reason = notification.userInfo?[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
        if (MPMovieFinishReason(rawValue: reason as! Int) == MPMovieFinishReason.UserExited) {
            self.playButton.setTitle("Play", forState: .Normal)
            self.playButton.removeTarget(self, action: nil, forControlEvents: .AllTouchEvents)
            self.playButton.addTarget(self, action: #selector(play(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    
    
    func videoPlayerViewControllerDidReceiveVideo(notification:NSNotification){
        
        self.playButton.setTitle("Play", forState: .Normal)
        self.playButton.removeTarget(self, action: nil, forControlEvents: .AllTouchEvents)
        self.playButton.addTarget(self, action: #selector(play(_:)), forControlEvents: .TouchUpInside)
     
        
    }

    @IBAction func play(sender:UIButton){
        self.youTubeVideoPlayer.presentInView(self.videoContainerView)
        self.youTubeVideoPlayer.moviePlayer.fullscreen = true
        self.youTubeVideoPlayer.moviePlayer.play()
    }
    
    
    
}
