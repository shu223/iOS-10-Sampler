//
//  PreviewInteractionPopViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class PreviewInteractionPopViewController: UIViewController {

    internal var animator: UIViewPropertyAnimator!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = nil
        
        animator = UIViewPropertyAnimator(duration: 0, curve: .linear) {
            self.effectView.effect = nil
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animator.fractionComplete = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
