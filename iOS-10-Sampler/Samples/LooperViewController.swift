//
//  LooperViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class LooperViewController: UIViewController {

    private var looper: PlayerLooper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoPath = Bundle.main.path(forResource: "superquest", ofType: "mp4") else {fatalError()}
        let videoUrl = URL(fileURLWithPath: videoPath)
        looper = PlayerLooper(videoURL: videoUrl, loopCount: -1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        looper.start(in: view.layer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        looper.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
