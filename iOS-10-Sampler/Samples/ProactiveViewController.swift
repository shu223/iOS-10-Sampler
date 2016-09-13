//
//  ProactiveViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/13/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ProactiveViewController: UIViewController, NSUserActivityDelegate, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var mapItem: MKMapItem!
    
    @IBOutlet weak var openinBtn: UIButton!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openinBtn.isEnabled = false
        label.text = "Getting current location..."
        locationManager.requestLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createUserActivity() {
        let activity = NSUserActivity(activityType: "com.shu223.iOS-10-Sampler.proactive")
        
        // Enable features
        activity.isEligibleForHandoff = false
        activity.isEligibleForSearch = true
        activity.isEligibleForPublicIndexing = true
        
        // Set delegate
        activity.delegate = self
        activity.needsSave = true
        
        // Provide a title and keywords
        activity.title = "iOS-10-Sampler"
        activity.keywords = ["ios", "10", "sampler"]
        
        /*
         Use the UIViewController's userActivity property, which is defined in
         UIResponder. UIKit will automatically manage this user activity and
         make it current when the view controller is present in the view
         hierarchy.
         */
        userActivity = activity
    }
    
    // =========================================================================
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(self.classForCoder)/" + #function)
        guard let location = locations.first else {
            showAlert(title: "Failed to obtain current location", message: "")
            return
        }
        
        let placemark = MKPlacemark(coordinate: location.coordinate)
        mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Suggested MapItem"
        mapItem.url = URL(string: "https://github.com/shu223")
        
        createUserActivity()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Failed to obtain current location", message: error.localizedDescription)
    }

    
    // =========================================================================
    // MARK: - NSUserActivityDelegate
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        print("\(self.classForCoder)/" + #function)
        if let mapItem = mapItem {
            activity.mapItem = mapItem
            openinBtn.isEnabled = true
            
            label.text = "or\nSee App Switcher by double tapping the home button. You can find a suggestion for getting the direction."
        }
    }
    
    // =========================================================================
    // MARK: - Actions
    
    @IBAction func openinBtnTapped(sender: UIButton) {
        userActivity?.mapItem.openInMaps(launchOptions: nil)
    }
}
