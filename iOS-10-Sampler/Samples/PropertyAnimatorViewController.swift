//
//  PropertyAnimatorViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/10/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class PropertyAnimatorViewController: UIViewController {

    @IBOutlet private weak var objectView: UIView!
    private var animator: UIViewPropertyAnimator?
    private var targetLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    private func goto(location: CGPoint) {
        targetLocation = location
        
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timing)
        guard let animator = animator else {return}
        animator.addAnimations {
            self.objectView.center = location
        }
        animator.startAnimation()
    }

    // =========================================================================
    // MARK: - Touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let loc = touch.location(in: view)

        goto(location: loc)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let loc = touch.location(in: view)
        
        if loc == targetLocation {
            return
        }

        goto(location: loc)
    }
}
