//
//  PreviewInteractionPopViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class PreviewInteractionPopViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true) { 
//            self.statusLabel.text = nil
//        }
//    }
}
