//
//  LooperViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class LooperViewController: UIViewController {

    private var looper: Looper!
    
    @IBOutlet private weak var minSlider: UISlider!
    @IBOutlet private weak var maxSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoPath = Bundle.main.path(forResource: "superquest_attack", ofType: "mp4") else {fatalError()}
        let videoUrl = URL(fileURLWithPath: videoPath)
        looper = Looper(videoURL: videoUrl)
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

    @IBAction func sliderChanged(sender: UISlider) {
        looper.stop()
        let result = looper.start(in: view.layer,
                                  startRate: Double(minSlider.value),
                                  endRate: Double(maxSlider.value))
        if !result {
            showAlert(title: "Invalid value", message: "Start or End seem to be wrong.")
        }
    }
}
