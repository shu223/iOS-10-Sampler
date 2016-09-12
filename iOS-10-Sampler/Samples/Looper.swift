//
//  Looper.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import AVFoundation

class Looper: NSObject {

    private let playerItemDurationKey = "duration"

    private let player = AVQueuePlayer()
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper!

    // MARK: Looper
    
    required init(videoURL: URL) {
        super.init()

        playerLayer.player = player

        let playerItem = AVPlayerItem(url: videoURL)
        playerItem.asset.loadValuesAsynchronously(forKeys: [playerItemDurationKey], completionHandler: {()->Void in
            /*
             The asset invokes its completion handler on an arbitrary queue when
             loading is complete. Because we want to access our AVPlayerLooper
             in our ensuing set-up, we must dispatch our handler to the main queue.
             */
            DispatchQueue.main.async(execute: {
                var durationError: NSError? = nil
                let durationStatus = playerItem.asset.statusOfValue(forKey: self.playerItemDurationKey,
                                                                    error: &durationError)
                guard durationStatus == .loaded else {
                    fatalError("Failed to load duration property with error: \(durationError)")
                }
                self.playerLooper = AVPlayerLooper(player: self.player, templateItem: playerItem)
            })
        })
    }
    
    func start(in parentLayer: CALayer) {
        parentLayer.addSublayer(playerLayer)
        playerLayer.frame = parentLayer.bounds
        player.play()
        
    }
    
    func stop() {
        player.pause()
        
        playerLooper.disableLooping()
        playerLooper = nil
        
        playerLayer.removeFromSuperlayer()
    }
}
