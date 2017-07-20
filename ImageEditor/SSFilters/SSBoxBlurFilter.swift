//
//  SSBoxBlurFilter.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 15.07.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import Foundation
import UIKit
class SSBoxBlurFilter: SSFilter {
    
    init(radius: Int) {
        super.init()
        filterName = "CIBoxBlur"
        filter = CIFilter(name: "\(filterName!)" )
        filter!.setDefaults()
        filter!.setValue(radius, forKey: kCIInputRadiusKey)
    }
}
