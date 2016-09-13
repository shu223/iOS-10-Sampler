# iOS-10-Sampler

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Twitter](https://img.shields.io/badge/twitter-@shu223-blue.svg?style=flat)](http://twitter.com/shu223)


Code examples for new APIs of iOS 10.


##How to build

Just build with Xcode 8.

It can **NOT** run on **Simulator**. (Because it uses Metal.)


##Contents

###Speech Recognition

Speech Recognition demo using Speech Framework. All available languages can be selected.

<img src="README_resources/speechrecognition.jpg" width="405">

###Looper

Loop playback demo using AVPlayerLooper.

<img src="README_resources/loop_normal.gif" align="left">
<img src="README_resources/loop_short.gif">
<br clear="all">

###Live Photo Capturing

Live Photo Capturing example using AVCapturePhotoOutput.

<img src="README_resources/livephoto.jpg" width="200">

###PropertyAnimator1

Animating UIView's `center` & `backgroundColor` using UIViewPropertyAnimator.

###PropertyAnimator2

Animating blur effect using `fractionComplete` property of UIViewPropertyAnimator.

###Audio Fade-in/out

Audio fade-in/out demo using `setVolume:fadeDuration` method which is added to AVAudioPlayer.

###Attributed Speech

Attributed Speech demo using `attributedSpeechString` of AVSpeechUtterance. But it seems NOT to affect the speech with this attribute. Anyone, please let me know how it works.
