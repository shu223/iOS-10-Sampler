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
        
        // Only setup observers and start the session running if setup succeeded.
        self.addObservers()

        switch LivePhotoCaptureSessionManager.sharedManager.setupResult {
        case .success:
            break
        case .notAuthorized:
            DispatchQueue.main.async { [unowned self] in
                let message = NSLocalizedString("AVCam doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
                let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { action in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        case .configurationFailed:
            DispatchQueue.main.async { [unowned self] in
                let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
                let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }

        LivePhotoCaptureSessionManager.sharedManager.startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        LivePhotoCaptureSessionManager.sharedManager.stopSession()
        self.removeObservers()

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
        /*
         Retrieve the video preview layer's video orientation on the main queue before
         entering the session queue. We do this to ensure UI elements are accessed on
         the main thread and session configuration is done on the session queue.
         */
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
