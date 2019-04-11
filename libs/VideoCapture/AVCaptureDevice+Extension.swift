//
//  AVCaptureDevice+Extension.swift
//
//  Created by Shuichi Tsutsumi on 4/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice {
    private func availableFormatsFor(preferredFps: Float64) -> [AVCaptureDevice.Format] {
        var availableFormats: [AVCaptureDevice.Format] = []
        for format in formats
        {
            let ranges = format.videoSupportedFrameRateRanges
            for range in ranges where range.minFrameRate <= preferredFps && preferredFps <= range.maxFrameRate
            {
                availableFormats.append(format)
            }
        }
        return availableFormats
    }
    
    private func formatWithHighestResolution(_ availableFormats: [AVCaptureDevice.Format]) -> AVCaptureDevice.Format?
    {
        var maxWidth: Int32 = 0
        var selectedFormat: AVCaptureDevice.Format?
        for format in availableFormats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let width = dimensions.width
            if width >= maxWidth {
                maxWidth = width
                selectedFormat = format
            }
        }
        return selectedFormat
    }
    
    private func formatFor(preferredSize: CGSize, availableFormats: [AVCaptureDevice.Format]) -> AVCaptureDevice.Format?
    {
        for format in availableFormats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            
            if dimensions.width >= Int32(preferredSize.width) && dimensions.height >= Int32(preferredSize.height)
            {
                return format
            }
        }
        return nil
    }
    
    
    func updateFormatWithPreferredVideoSpec(preferredSpec: VideoSpec)
    {
        let availableFormats: [AVCaptureDevice.Format]
        if let preferredFps = preferredSpec.fps {
            availableFormats = availableFormatsFor(preferredFps: Float64(preferredFps))
        } else {
            availableFormats = formats
        }
        
        var format: AVCaptureDevice.Format?
        if let preferredSize = preferredSpec.size {
            format = formatFor(preferredSize: preferredSize, availableFormats: availableFormats)
        } else {
            format = formatWithHighestResolution(availableFormats)
        }
        
        guard let selectedFormat = format else {return}
        print("selected format: \(selectedFormat)")
        do {
            try lockForConfiguration()
        } catch {
            fatalError("")
        }
        activeFormat = selectedFormat
        
        if let preferredFps = preferredSpec.fps {
            activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: preferredFps)
            activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: preferredFps)
            unlockForConfiguration()
        }
    }
}
