//
//  SampleDataSource.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

struct Sample {
    let title: String
    let detail: String
    let classPrefix: String
    
    func controller() -> UIViewController {
        let storyboard = UIStoryboard(name: classPrefix, bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {fatalError()}
        controller.title = title
        return controller
    }
}

struct SampleDataSource {
    let samples = [
        Sample(
            title: "Live Photo Capturing",
            detail: "Live Photo Capturing example using AVCapturePhotoOutput.",
            classPrefix: "LivePhotoCapture"
        ),
        Sample(
            title: "Speech Recognition",
            detail: "Speech Recognition demo using Speech Framework. All available language can be selected.",
            classPrefix: "SpeechRecognition"
        ),
        Sample(
            title: "Looper",
            detail: "Loop playback demo using AVPlayerLooper.",
            classPrefix: "Looper"
        ),
        Sample(
            title: "Audio Fade-in/out",
            detail: "Audio fade-in/out demo.",
            classPrefix: "AudioFadeInOut"
        ),
        Sample(
            title: "MPSCNN Basic",
            detail: "Hand-writing digit detection using Convolutional Neural Networks by Metal Performance Shaders.",
            classPrefix: "MetalCNNBasic"
        ),
        Sample(
            title: "Metal Image Recognition",
            detail: "Real-time image recognition using CNN by Metal Performance Shaders.",
            classPrefix: "MetalImageRecognition"
        ),
        Sample(
            title: "New filters",
            detail: "New filters of CIImage.",
            classPrefix: "ImageFilters"
        ),
        Sample(
            title: "PropertyAnimator: Position",
            detail: "Animating view's position & color using UIViewPropertyAnimator.",
            classPrefix: "PropertyAnimator"
        ),
        Sample(
            title: "PropertyAnimator: Blur",
            detail: "Animating blur effect using UIViewPropertyAnimator.",
            classPrefix: "PropertyAnimatorEffect"
        ),
        Sample(
            title: "Preview Interaction",
            detail: "Peek & Pop interactions with 3D touch using UIPreviewInteraction.",
            classPrefix: "PreviewInteraction"
        ),
        Sample(
            title: "UserNotification",
            detail: "Local notification with an image using UserNotifications framework.",
            classPrefix: "UserNotification"
        ),
        Sample(
            title: "Sticker Pack",
            detail: "Example of Sticker Pack for iMessage",
            classPrefix: "StickerPack"
        ),
        Sample(title: "Core Data Stack",
               detail: "Simple Core Data stack using NSPersistentContainer",
               classPrefix: "PersistentContainer"
        ),
        Sample(
            title: "TabBar Customization",
            detail: "Customization sample for UITabBar's badge using text attributes.",
            classPrefix: "TabBadge"
        ),
        Sample(
            title: "New Fonts",
            detail: "New Fonts gallery",
            classPrefix: "Fonts"
        ),
        Sample(
            title: "Proactive: Location Suggestions",
            detail: "This sample demonstrates how to use new `mapItem` property of NSUserActivity to integrate with location suggestions",
            classPrefix: "Proactive"
        ),
        Sample(
            title: "Attributed Speech",
            detail: "Attributed Speech demo using attributedSpeechString of AVSpeechUtterance.",
            classPrefix: "AttributedSpeech"
        ),
        ]
}
