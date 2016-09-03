//
//  AudioFadeInOutViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import AVFoundation

class AudioFadeInOutViewController: UIViewController {

    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let asset = NSDataAsset(name: "bgm") else {fatalError()}
        do {
            player = try AVAudioPlayer(data: asset.data)
        }
        catch {
            fatalError()
        }
        player.numberOfLoops = -1
        player.volume = 0
        
        print(player.format)    // New
        
        player.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSwitchChanged(sender: UISwitch) {
        if sender.isOn {
            // Fade In
            player.setVolume(1, fadeDuration: 3)
        } else {
            // Fade Out
            player.setVolume(0, fadeDuration: 3)
        }
        
    }

}
