//
//  GalleryVC.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 25.07.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit

class GalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photosCv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        photosCv.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
