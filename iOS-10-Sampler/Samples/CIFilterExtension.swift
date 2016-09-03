//
//  CIFilterExtension.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import Foundation
import CoreImage

extension CIFilter {
    func categories() -> [String] {
        guard let categories = attributes[kCIAttributeFilterCategories] as? [String] else {fatalError()}
        return categories
    }
    
    func available_iOS() -> Int {
        guard let versionStr = attributes[kCIAttributeFilterAvailable_iOS] as? String else {return 0}
        guard let versionInt = Int(versionStr) else {return 0}
        return versionInt
    }
    
    static func names(available_iOS: Int, category: String?, exceptCategories: [String]? = nil) -> [String] {
        let names = CIFilter.filterNames(inCategory: category).filter { (name) -> Bool in
            guard let filter = CIFilter(name: name) else {fatalError()}
            
            if let exceptCategories = exceptCategories {
                for aCategory in filter.categories() where exceptCategories.contains(aCategory) == true {
                    return false
                }
            }
            
            if filter.available_iOS() == available_iOS {
                return true
            } else {
                return false
            }
        }
        return names
    }
}
