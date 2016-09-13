//
//  LivePhotoCaptureViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/5/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//  [Reference] This sample is based on the Apple's sample "AVCam-iOS".

import UIKit

class LivePhotoCaptureViewController: UIViewController {

    @IBOutlet private weak var previewView: PreviewView!
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var capturingLivePhotoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the video preview view.
        previewView.session = LivePhotoCaptureSessionManager.sharedManager.session
        
        LivePhotoCaptureSessionManager.sharedManager.authorize()

        LivePhotoCaptureSessionManager.sharedManager.configureSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        LivePhotoCaptureSessionManager.sharedManager.startSession(handler: { [unowned self] (isStarted) in
            if isStarted {
                // Only setup observers and start the session running if setup succeeded.
                self.addObservers()
            } else {
                switch LivePhotoCaptureSessionManager.sharedManager.setupResult {
                case .success:
                    break
                case .notAuthorized:
                    self.showAlert(
                        title: "Not Authorized",
                        message: "Doesn't have permission to use the camera, please change privacy settings")
                case .notSupported:
                    self.showAlert(
                        title: "Not Supported",
                        message: "Live photo captureling is not supported on this device.")
                case .configurationFailed:
                    self.showAlert(
                        title: "Configuration Failed",
                        message: "Unable to capture media")
                }
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        if LivePhotoCaptureSessionManager.sharedManager.isSessionRunning {
            LivePhotoCaptureSessionManager.sharedManager.stopSession()
            self.removeObservers()            
        }

        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
    
    // =========================================================================
    // MARK: - KVO and Notifications
    
    private var sessionRunningObserveContext = 0
    
    private func addObservers() {
        LivePhotoCaptureSessionManager.sharedManager.session.addObserver(self, forKeyPath: "running", options: .new, context: &sessionRunningObserveContext)
    }
    
    private func removeObservers() {
        LivePhotoCaptureSessionManager.sharedManager.session.removeObserver(self, forKeyPath: "running", context: &sessionRunningObserveContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &sessionRunningObserveContext {
            guard let isSessionRunning = (change?[.newKey] as AnyObject).boolValue else { return }
            
            DispatchQueue.main.async { [unowned self] in
                self.photoButton.isEnabled = isSessionRunning
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // =========================================================================
    // MARK: - Actions
    
    @IBAction private func capturePhoto(_ photoButton: UIButton) {
        let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection.videoOrientation
        LivePhotoCaptureSessionManager.sharedManager.capture(videoOrientation: videoPreviewLayerOrientation) { (inProgressLivePhotoCapturesCount) in
            DispatchQueue.main.async { [unowned self] in
                if inProgressLivePhotoCapturesCount > 0 {
                    self.capturingLivePhotoLabel.isHidden = false
                }
                else if inProgressLivePhotoCapturesCount == 0 {
                    self.capturingLivePhotoLabel.isHidden = true
                }
                else {
                    print("Error: In progress live photo capture count is less than 0");
                }
            }
        }
    }
}
