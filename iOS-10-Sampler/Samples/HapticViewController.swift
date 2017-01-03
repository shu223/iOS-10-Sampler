//
//  HapticViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 2017/01/03.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class HapticViewController: UIViewController {

    private var impactFeedbacker: UIImpactFeedbackGenerator!
    private let notificationFeedbacker = UINotificationFeedbackGenerator()
    private let selectionFeedbacker = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationFeedbacker.prepare()
        selectionFeedbacker.prepare()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func impactBtnTapped(_ sender: UIButton) {
        guard let style = UIImpactFeedbackStyle(rawValue: sender.tag) else {fatalError()}
        impactFeedbacker = UIImpactFeedbackGenerator(style: style)
        impactFeedbacker.prepare()
        impactFeedbacker.impactOccurred()
    }

    @IBAction func notificationBtnTapped(_ sender: UIButton) {
        guard let type = UINotificationFeedbackType(rawValue: sender.tag) else {fatalError()}
        notificationFeedbacker.notificationOccurred(type)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        selectionFeedbacker.selectionChanged()
    }
}
