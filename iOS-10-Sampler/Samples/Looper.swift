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
    }
    
    func start(in parentLayer: CALayer) {
        start(in: parentLayer, startRate: 0, endRate: 1)
    }

    @discardableResult func start(in parentLayer: CALayer, startRate: Double, endRate: Double) -> Bool {
        guard startRate >= 0.0 && endRate >= 0.0 &&
            startRate <= 1.0 && endRate <= 1.0 &&
            startRate < endRate else {
                return false
        }
        let duration = playerItem.asset.duration
        let start = CMTime(seconds: duration.seconds * startRate, preferredTimescale: duration.timescale)
        let end = CMTime(seconds: duration.seconds * endRate, preferredTimescale: duration.timescale)
        let timeRange = CMTimeRange(start: start, end: end)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem, timeRange: timeRange)

        // Getting the natural size of the video
        // http://stackoverflow.com/questions/14466842/ios-6-avplayeritem-presentationsize-returning-zero-naturalsize-method-deprec
        let videoTracks = playerItem.asset.tracks(withMediaType: .video)
        guard let videoSize = videoTracks.first?.naturalSize else {fatalError()}
        
        parentLayer.addSublayer(playerLayer)
        playerLayer.frame.size = videoSize
        playerLayer.position = CGPoint(x: parentLayer.frame.midX, y: parentLayer.frame.midY)
        player.play()
        
        return true
    }
    
    func stop() {
        player.pause()

        if let playerLooper = playerLooper {
            playerLooper.disableLooping()
        }
        playerLooper = nil
        
        playerLayer.removeFromSuperlayer()
    }
}
