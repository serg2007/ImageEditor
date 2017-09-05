//
//  ImageCollectionViewCell.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 30.08.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
    }
    
    var imageUrl: URL? {
        didSet{
            mainImage.image = nil
            loaderView.startAnimating()
            loaderView.isHidden = false
            mainImage.downloadImage(url: imageUrl!){
                DispatchQueue.main.async {
                    
                    self.loaderView.stopAnimating()
                    self.loaderView.isHidden = true
                }
            }
        }
    }
    
}
