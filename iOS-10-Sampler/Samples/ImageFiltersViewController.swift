//
//  ImageFiltersViewController.swift
//  iOS-10-Sampler
//
//  Created by Shuichi Tsutsumi on 9/3/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import CoreImage

class ImageFiltersViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var picker: UIPickerView!
    @IBOutlet weak private var indicator: UIActivityIndicatorView!

    private var items: [String]!
    private var orgImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orgImage = imageView.image
        items = CIFilter.names(available_iOS: 10, category: kCICategoryBuiltIn)
        items.insert("Original", at: 0)
        print("filters:\(items)\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func applyFilter(name: String, handler: ((UIImage?) -> Void)) {
        let inputImage = CIImage(image: self.orgImage)!
        guard let filter = CIFilter(name: name) else {fatalError()}
        let attributes = filter.attributes
        
        if attributes[kCIInputImageKey] == nil {
            print("\(name) has no inputImage property.")
            handler(nil)
            return
        }

        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setDefaults()
        
        // for CIShadedMaterial
        if attributes["inputShadingImage"] != nil {
            filter.setValue(inputImage, forKey: "inputShadingImage")
        }
        
        // Apply filter
        let context = CIContext(options: nil)
        guard let outputImage = filter.outputImage else {
            handler(nil)
            return
        }
        
        var extent = outputImage.extent
        // let scale = UIScreen.mainScreen().scale
        let scale: CGFloat!
        
        // some outputImage have infinite extents. e.g. CIDroste
        if extent.isInfinite {
            let size = self.imageView.frame.size
            scale = UIScreen.main.scale
            extent = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        } else {
            scale = extent.size.width / self.orgImage.size.width
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: extent) else {fatalError()}
        let image = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
        print("extent:\(extent), image:\(image), org:\(self.orgImage), scale:\(scale)\n")
        
        handler(image)
    }
    
    // =========================================================================
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    // =========================================================================
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            imageView.image = orgImage
            return
        }
        
        indicator.startAnimating()
        
        DispatchQueue.global(qos: .default).async {
            self.applyFilter(name: self.items[row], handler: { (image) in
                DispatchQueue.main.async(execute: {
                    self.imageView.image = image
                    self.indicator.stopAnimating()
                })
            })
        }
    }

}

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
