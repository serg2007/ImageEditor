//
//  SSBoxBlurFilter.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 15.07.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import Foundation
import UIKit
class SSColorClampFilter: SSFilter {
    
    override init() {
        super.init()
        filterName = "CIColorClamp"
        let minVector = CIVector(x: 0.06, y: 0.06, z: 0.06, w: 0)
        let maxVector = CIVector(x: 0.7, y: 0.7, z: 0.7, w: 1)

        filter = CIFilter(name: "\(filterName!)" )
        filter!.setDefaults()
        filter!.setValue(minVector, forKey: "inputMinComponents")
        filter!.setValue(maxVector, forKey: "inputMaxComponents")

    }
}
