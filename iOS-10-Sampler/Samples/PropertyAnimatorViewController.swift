//
//  PropertyAnimatorViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/10/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class PropertyAnimatorViewController: UIViewController {

    private var targetLocation: CGPoint!
    
    @IBOutlet private weak var objectView: UIView!
    @IBOutlet weak var springSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        objectView.backgroundColor = colorAt(location: objectView.center)
        targetLocation = objectView.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func colorAt(location: CGPoint) -> UIColor {
        let hue: CGFloat = (location.x / UIScreen.main.bounds.width + location.y / UIScreen.main.bounds.height) / 2
        return UIColor(hue: hue, saturation: 0.78, brightness: 0.75, alpha: 1)
    }

    private func processTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {return}
        let loc = touch.location(in: view)
        
        if loc == targetLocation {
            return
        }
        
        animateTo(location: loc)
    }
    
    private func animateTo(location: CGPoint) {
        var duration: TimeInterval
        var timing: UITimingCurveProvider
        if !springSwitch.isOn {
            duration = 0.4
            timing = UICubicTimingParameters(animationCurve: .easeOut)
        } else {
            duration = 0.6
            timing = UISpringTimingParameters(dampingRatio: 0.5)
        }

        let animator = UIViewPropertyAnimator(
            duration: duration,
            timingParameters: timing)

        animator.addAnimations {
            self.objectView.center = location
            self.objectView.backgroundColor = self.colorAt(location: location)
        }

        animator.startAnimation()

        targetLocation = location
    }

    // =========================================================================
    // MARK: - Touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        processTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        processTouches(touches)
    }
}
