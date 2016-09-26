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
    private let baseStr = "iOS 10 Sampler is a collection of code examples for new APIs of iOS 10."
    private var attributedStr: NSMutableAttributedString!
    private var utterance: AVSpeechUtterance!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attributedStr = NSMutableAttributedString(string: baseStr)
        let rangeAll = NSMakeRange(0, baseStr.characters.count)
        let rangeBold = NSString(string: baseStr).range(of: "iOS")
        attributedStr.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14)], range: rangeAll)
        attributedStr.addAttributes([NSForegroundColorAttributeName: UIColor.black], range: rangeAll)
        attributedStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)], range: rangeBold)
        
        updateUtterance(attributed: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateUtterance(attributed: Bool) {
        if attributed {
            utterance = AVSpeechUtterance(attributedString: attributedStr)
            label.attributedText = attributedStr
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
