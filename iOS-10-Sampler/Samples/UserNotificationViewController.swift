//
//  UserNotificationViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/4/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import UserNotifications

class UserNotificationViewController: UIViewController, UNUserNotificationCenterDelegate {

    private let baseId = "com.shu223.ios10sampler"
    private let moviePath = Bundle.main.path(forResource: "superquest", ofType: "mp4")!
    private var movieAttachment: UNNotificationAttachment!
    private let content = UNMutableNotificationContent()
    private let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    private var request: UNNotificationRequest!

    @IBOutlet private weak var notifyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Request authorization
        requestAuthorization()

        // Initializa attatchments
        movieAttachment = try! UNNotificationAttachment(
            identifier: "\(baseId).attachment",
            url: URL(fileURLWithPath: moviePath),
            options: nil)

        // Build content
        content.title = "iOS-10-Sampler"
        content.body = "This is the body."
        content.sound = UNNotificationSound.default
        content.attachments = [movieAttachment]
        
        // Initializa request
        request = UNNotificationRequest(
            identifier: "\(baseId).notification",
            content: content,
            trigger: trigger)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func requestAuthorization() {
        notifyBtn.isEnabled = false
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("error:\(error)")
            } else if !granted {
                print("not granted")
            } else {
                DispatchQueue.main.async(execute: {
                    self.notifyBtn.isEnabled = true
                })
            }
        }
    }
    
    // =========================================================================
    // MARK: - UNNotificationCenterDelegate
    
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        print("\(self.classForCoder)/" + #function)
    }
    
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        print("\(self.classForCoder)/" + #function)
    }
    
    // =========================================================================
    // MARK: - Actions
    
    @IBAction func notifyBtnTapped(sender: UIButton) {
        
        UNUserNotificationCenter.current().add(request) { (error) in
            UNUserNotificationCenter.current().delegate = self
            if let error = error {
                print("error:\(error)")
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let alert = UIAlertController(
                    title: "Close this app",
                    message: "A local notification has been scheduled. Close this app and wait 10 sec.",
                    preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style: UIAlertAction.Style.cancel,
                    handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
