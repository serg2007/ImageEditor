//
//  ViewController.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 12.07.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit

class ImageEditorVC: UIViewController {

    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var scrPreview: UIScrollView!
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
//        "CIPhotoEffectFade",
//        "CIPhotoEffectInstant",
//        "CIPhotoEffectNoir",
//        "CIPhotoEffectProcess",
//        "CIPhotoEffectTonal",
//        "CIPhotoEffectTransfer",
//        "CISepiaTone",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        
        var itemCount = 0
        
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect.init(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(ImageEditorVC.filterButtonTapped(sender:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            let imageForButton = filter(image: imgMain.image!, filterName: CIFilterNames[i])
            
            // Assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            // Add Buttons in the Scroll View
            xCoord +=  buttonWidth + gapBetweenButtons
            scrPreview.addSubview(filterButton)
        } // END FOR LOOP
        
        
        // Resize Scroll View
        scrPreview.contentSize = CGSize.init(width: buttonWidth * CGFloat(itemCount+2), height: yCoord)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filter(image: UIImage, filterName: String) -> UIImage {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: "\(filterName)" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        return UIImage(cgImage: filteredImageRef!);
    }
    
    @objc func filterButtonTapped(sender: UIButton) {
        let button = sender as UIButton
        let filter = SSColorClampFilter()
//        let filter2 = SSDiscBlurFilter(radius: 6)

        filter.applyFilter(image: imgMain.image!) { (image) in
            self.imgMain.image = image
        }
//            button.backgroundImage(for: .normal)
    }

}

