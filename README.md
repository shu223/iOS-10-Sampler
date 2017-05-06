# iOS-10-Sampler

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Twitter](https://img.shields.io/badge/twitter-@shu223-blue.svg?style=flat)](http://twitter.com/shu223)


Code examples for new APIs of iOS 10.


## How to build

Just build with Xcode 8.

It can **NOT** run on **Simulator**. (Because it uses Metal.)


## Contents

### Speech Recognition

Speech Recognition demo using Speech Framework. All available languages can be selected.

<img src="README_resources/speechrecognition.jpg" width="405">

### Looper

Loop playback demo using AVPlayerLooper.

<img src="README_resources/loop_normal.gif" align="left"> <img src="README_resources/loop_short.gif">
<br clear="all">

### Live Photo Capturing

Live Photo Capturing example using AVCapturePhotoOutput.

<img src="README_resources/livephoto.jpg" width="200">

### Audio Fade-in/out

Audio fade-in/out demo using `setVolume:fadeDuration` method which is added to AVAudioPlayer.

### Metal CNN Basic: Digit Detection

Hand-writing digit detection using CNN (Convolutional Neural Network) by Metal Performance Shaders.

<img src="README_resources/digit.gif">

### Metal CNN Advanced: Image Recognition

Real-time image recognition using CNN (Convolutional Neural Network) by Metal Performance Shaders.

<img src="README_resources/imagerecog.gif">

### PropertyAnimator: Position

Animating UIView's `center` & `backgroundColor` using UIViewPropertyAnimator.

<img src="README_resources/animator1.gif">

### PropertyAnimator: Blur

Animating blur effect using `fractionComplete` property of UIViewPropertyAnimator.

<img src="README_resources/animator2.gif">

### Preview Interaction

**Peek & Pop interactions with 3D touch** using UIPreviewInteraction.

<img src="README_resources/peekpop.gif">

### Notification with Image

Local notification with an image using UserNotifications framework.

<img src="README_resources/notif1.jpg" width="200" alighn="left"> <img src="README_resources/notif2.jpg" width="200">
<br clear="all">

### Sticker Pack

Example of Sticker Pack for iMessage.

<img src="README_resources/stickers.jpg" width="200">

### Core Data Stack (Created by [nolili](https://github.com/nolili))

Simple Core Data stack using NSPersistentContainer.

<img src="README_resources/coredata.jpg" width="200">

### TabBar Customization

Customization sample for UITabBar's badge using text attributes.

<img src="README_resources/tab.jpg" width="200">

### New filters

New filters of CIFilter in Core Image.

<img src="README_resources/filter1.jpg" width="200" alighn="left"> <img src="README_resources/filter2.jpg" width="200">
<br clear="all">

### New Fonts

New Fonts gallery

<img src="README_resources/fonts.jpg" width="200">

### Proactive: Location Suggestions

This sample demonstrates how to use new `mapItem` property of NSUserActivity to integrate with location suggestions.

<img src="README_resources/proactive1.jpg" width="200" alighn="left"> <img src="README_resources/proactive2.jpg" width="200">
<br clear="all">

### Attributed Speech

Attributed Speech demo using `attributedSpeechString` of AVSpeechUtterance. 

But it seems **NOT** to affect the speech with this attribute. Anyone, please let me know how to use this new API.

### Haptic Feedback

Haptic Feedbacks using UIFeedbackGenerator.

<img src="README_resources/haptic.jpg" width="200">


## Author

**Shuichi Tsutsumi**

Freelance iOS programmer in Japan.

- PAST WORKS:  [My Profile Summary](https://medium.com/@shu223/my-profile-summary-f14bfc1e7099#.vdh0i7clr)
- PROFILES: [LinkedIn](https://www.linkedin.com/profile/view?id=214896557)
- BLOGS: [English](https://medium.com/@shu223/) / [Japanese](http://d.hatena.ne.jp/shu223/)
- CONTACTS: [Twitter](https://twitter.com/shu223) / [Facebook](https://www.facebook.com/shuichi.tsutsumi)


## Special Thanks

The icon is designed by [Okazu](https://www.facebook.com/pashimo)
