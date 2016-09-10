//
//  TabBadgeViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/10/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class TabBadgeViewController: UIViewController, UITabBarDelegate {

    var badgeCnt: UInt = 0
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first

        // New!
        tabBar.unselectedItemTintColor = UIColor.magenta.withAlphaComponent(0.2)

        guard let items = tabBar.items else {fatalError()}
        for item in items where item != tabBar.selectedItem {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            shadow.shadowBlurRadius = 5
            let attributes: [String : Any] = [NSFontAttributeName: UIFont(name: "Menlo-Bold", size: 50)!,
                                              NSForegroundColorAttributeName: UIColor.magenta,
                                              NSShadowAttributeName: shadow]
            // New!
            item.setBadgeTextAttributes(attributes, for: .normal)

            // New!
            item.badgeColor = UIColor.clear
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // =========================================================================
    // MARK: - UITabBarDelegate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        badgeCnt = 0
        item.badgeValue = nil
    }
    
    // =========================================================================
    // MARK: - Actions
    
    @IBAction func countBtnTapped(sender: UIButton) {
        badgeCnt += 1
        
        guard let items = tabBar.items else {fatalError()}
        for item in items where item != tabBar.selectedItem {
            item.badgeValue = "\(badgeCnt)"
        }
    }
}
