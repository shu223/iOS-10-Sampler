//
//  PreviewInteractionViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class PreviewInteractionViewController: UIViewController, UIPreviewInteractionDelegate {

    private var previewInteraction: UIPreviewInteraction!
    private var popVC: PreviewInteractionPopViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        previewInteraction = UIPreviewInteraction(view: view)
        previewInteraction.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PreviewInteractionPopViewController {
            popVC = vc
        }
    }

    // =========================================================================
    // MARK: - UIPreviewInteractionDelegate
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
//        print("\(self.classForCoder)/" + #function + ", transition:\(transitionProgress), ended:\(ended)")
        if popVC == nil {
            performSegue(withIdentifier: "Pop", sender: nil)
        }

        if ended {
            popVC?.statusLabel.text = "Peek!"
        }
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdateCommitTransition transitionProgress: CGFloat, ended: Bool) {
//        print("\(self.classForCoder)/" + #function + ", transition:\(transitionProgress), ended:\(ended)")
        popVC?.animator.fractionComplete = transitionProgress
        if ended {
            popVC?.statusLabel.text = "Pop!"
        }
    }
    
    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
        dismiss(animated: true) { 
            self.popVC?.statusLabel.text = nil
            self.popVC = nil
        }
    }
    
    @IBAction func unwindAction(segue: UIStoryboardSegue) {
        popVC = nil
    }
}
