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
    @IBOutlet private weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first

        // New!
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.4)
        
        guard let items = tabBar.items else {fatalError()}
        for item in items where item != tabBar.selectedItem {
            let shadow = NSShadow()
            shadow.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            shadow.shadowBlurRadius = 3
            let attributes: [String : Any] = [NSAttributedStringKey.font.rawValue: UIFont(name: "Menlo-Bold", size: 30)!,
                                              NSAttributedStringKey.foregroundColor.rawValue: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                                              NSAttributedStringKey.shadow.rawValue: shadow]
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
