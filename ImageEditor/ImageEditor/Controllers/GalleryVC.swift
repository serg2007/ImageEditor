//
//  GalleryVC.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 25.07.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit
import Photos



class GalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let cachingImageManager = PHCachingImageManager()
    var assets: [PHAsset] = []
    var tempTransitionView: UIView?

    @IBOutlet weak var photosCv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = PHFetchOptions()
//        options.predicate = NSPredicate(format: "")
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let results = PHAsset.fetchAssets(with: .image, options: options)
        results.enumerateObjects({ (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        })
        self.assets.sort(){$0.creationDate! > $1.creationDate!}
        
        photosCv.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCollectionViewCell
        
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = assets[indexPath.row]

        
        cell.tag = Int(manager.requestImage(for: asset,
                    targetSize: CGSize(width: 100.0, height: 100.0),
                    contentMode: .aspectFill,
                    options: nil) { (result, _) in
                            cell.mainImg.image = result
                    })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        let frame = UIApplication.shared.keyWindow?.bounds
        tempTransitionView = UIView(frame: frame!)
        tempTransitionView?.backgroundColor = UIColor.cyan
//        tempTransitionView?.isExclusiveTouch = true
        UIApplication.shared.keyWindow?.addSubview(tempTransitionView!)
        let collectionViewAttribute = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect = collectionViewAttribute?.frame
        
        let cellFrameInSuperview = collectionView.convert(cellRect!, to: tempTransitionView)
        
        let dragableView = DraggableView(image: cell.mainImg.image!, frame: cellFrameInSuperview)
        
        
        tempTransitionView?.addSubview(dragableView)
        dragableView.becomeFirstResponder()
//        dragableView.isExclusiveTouch = true
//        dragableView.pan?.perfomTouch(location: nil, translation: nil, state: .began)
        return true

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

    }
}
