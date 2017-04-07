//
//  AVCaptureDevice+Extension.swift
//
//  Created by Shuichi Tsutsumi on 4/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice {
    private func availableFormatsFor(preferredFps: Float64) -> [AVCaptureDeviceFormat] {
        guard let allFormats = formats as? [AVCaptureDeviceFormat] else {
            return []
        }
        
        var availableFormats: [AVCaptureDeviceFormat] = []
        for format in allFormats
        {
            guard let ranges = format.videoSupportedFrameRateRanges as? [AVFrameRateRange] else {
                continue
            }
            
            for range in ranges where range.minFrameRate <= preferredFps && preferredFps <= range.maxFrameRate
            {
                availableFormats.append(format)
            }
        }
        return availableFormats
    }
    
    private func formatWithHighestResolution(_ availableFormats: [AVCaptureDeviceFormat]) -> AVCaptureDeviceFormat?
    {
        var maxWidth: Int32 = 0
        var selectedFormat: AVCaptureDeviceFormat?
        for format in availableFormats {
            guard let desc = format.formatDescription else {continue}
            let dimensions = CMVideoFormatDescriptionGetDimensions(desc)
            let width = dimensions.width
            if width >= maxWidth {
                maxWidth = width
                selectedFormat = format
            }
        }
        return selectedFormat
    }
    
    private func formatFor(preferredSize: CGSize, availableFormats: [AVCaptureDeviceFormat]) -> AVCaptureDeviceFormat?
    {
        for format in availableFormats {
            guard let desc = format.formatDescription else {continue}
            let dimensions = CMVideoFormatDescriptionGetDimensions(desc)
            
            if dimensions.width >= Int32(preferredSize.width) && dimensions.height >= Int32(preferredSize.height)
            {
                return format
            }
        }
        return nil
    }
    
    
    func updateFormatWithPreferredVideoSpec(preferredSpec: VideoSpec)
    {
        let availableFormats: [AVCaptureDeviceFormat]
        if let preferredFps = preferredSpec.fps {
            availableFormats = availableFormatsFor(preferredFps: Float64(preferredFps))
        }
        else {
            guard let allFormats = formats as? [AVCaptureDeviceFormat] else { return }
            availableFormats = allFormats
        }
        
        var selectedFormat: AVCaptureDeviceFormat?
        if let preferredSize = preferredSpec.size {
            selectedFormat = formatFor(preferredSize: preferredSize, availableFormats: availableFormats)
        } else {
            selectedFormat = formatWithHighestResolution(availableFormats)
        }
        print("selected format: \(String(describing: selectedFormat))")
        
        if let selectedFormat = selectedFormat {
            do {
                try lockForConfiguration()
            }
            catch {
                fatalError("")
            }
            activeFormat = selectedFormat
            
            if let preferredFps = preferredSpec.fps {
                activeVideoMinFrameDuration = CMTimeMake(1, preferredFps)
                activeVideoMaxFrameDuration = CMTimeMake(1, preferredFps)
                unlockForConfiguration()
            }
        }
    }
}
