//
//  PreviewView.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/5/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
//  [Reference] This sample is based on the Apple's sample "AVCam-iOS".

import UIKit
import AVFoundation

class PreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // MARK: UIView
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
