//
//  StickerPackViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class StickerPackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func openBtnTapped(sender: UIButton) {
        let url = URL(string: "sms:")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}
