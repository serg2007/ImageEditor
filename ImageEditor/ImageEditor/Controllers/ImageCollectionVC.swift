//
//  ImageCollectionVC.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 30.08.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit
import AmazonS3RequestManager
import CoreData

class AssetExtractor {
    
    static func createLocalUrl(forImageNamed name: String) -> URL? {
        
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path
        
        guard fileManager.fileExists(atPath: path) else {
            guard
                let image = UIImage(named: name),
                let data = UIImagePNGRepresentation(image)
                else { return nil }
            
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }
        
        return url
    }
    
}

class ImageCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "imageCollectionViewCell"
    var images = [ImageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let postService = PostsService()
        postService.getAllPosts() {images in
            self.images = images
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
//        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//            let request: NSFetchRequest<PostModel> = PostModel.fetchRequest()
//            let context = appDelegate.persistentContainer.viewContext
//            do {
//                images = try context.fetch(request)
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            } catch {
//                print("Error")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        let image = images[indexPath.row]
        // Configure the cell
        
        cell.imageUrl = URL(string: image.imageName)
            
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 1
        let spaceBetweenCells: CGFloat = 10
        let dim = (collectionView.bounds.width - spaceBetweenCells)
        
        return CGSize(width: dim, height: collectionView.bounds.height - 100)
    }
}
