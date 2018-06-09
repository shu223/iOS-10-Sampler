//
//  AttributedSpeechViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import AVFoundation

class AttributedSpeechViewController: UIViewController {

    @IBOutlet private weak var label: UILabel!
    
    private let speech = AVSpeechSynthesizer()
    private let baseStr = "Tsutsumi"
    private var attributedStr: NSMutableAttributedString!
    private var utterance: AVSpeechUtterance!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attributedStr = NSMutableAttributedString(string: baseStr)
        let rangeAll = NSMakeRange(0, baseStr.count)
        attributedStr.addAttribute(NSAttributedStringKey(rawValue: AVSpeechSynthesisIPANotationAttribute), value: "tən.tən.mi", range: rangeAll)
        updateUtterance(attributed: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateUtterance(attributed: Bool) {
        if attributed {
            utterance = AVSpeechUtterance(attributedString: attributedStr)
            label.text = baseStr + " (attributed)"
        } else {
            utterance = AVSpeechUtterance(string: baseStr)
            label.text = baseStr
        }
    }
    
    // =========================================================================
    // MARK: - Actions
    
    @IBAction func speechBtnTapped(sender: UIButton) {
        if speech.isSpeaking {
            print("already speaking...")
            return
        }
        speech.speak(utterance)
    }

    @IBAction func switchChanged(sender: UISwitch) {
        updateUtterance(attributed: sender.isOn)
    }

}
