//
//  Looper.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import AVFoundation

class Looper: NSObject {

    private var playerItem: AVPlayerItem!
    private let player = AVQueuePlayer()
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper!
    
    required init(videoURL: URL) {
        super.init()

        playerLayer.player = player

        playerItem = AVPlayerItem(url: videoURL)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
    }
    
    func start(in parentLayer: CALayer) {
        // Getting the natural size of the video
        // http://stackoverflow.com/questions/14466842/ios-6-avplayeritem-presentationsize-returning-zero-naturalsize-method-deprec
        let videoTracks = playerItem.asset.tracks(withMediaType: AVMediaTypeVideo)
        guard let videoSize = videoTracks.first?.naturalSize else {fatalError()}
        
        parentLayer.addSublayer(playerLayer)
        playerLayer.frame.size = videoSize
        playerLayer.position = CGPoint(x: parentLayer.frame.midX, y: parentLayer.frame.midY)
        player.play()
        
    }
    
    func stop() {
        player.pause()
        
        playerLooper.disableLooping()
        playerLooper = nil
        
        playerLayer.removeFromSuperlayer()
    }
}
