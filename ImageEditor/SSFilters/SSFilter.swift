//
//  SSFilter.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 15.07.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import Foundation
import UIKit

class SSFilter {
    var filterName: String?
    var filter: CIFilter?
    
    init() {}
    
    func applyFilter(image: UIImage, callback: @escaping (UIImage)->Void) {
        DispatchQueue.global(qos: .background).async {
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: image)
            self.filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = self.filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let image = UIImage(cgImage: filteredImageRef!)
            DispatchQueue.main.async {
                callback(image)
            }
        }
    }
}
