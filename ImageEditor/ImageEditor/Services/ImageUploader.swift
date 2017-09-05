//
//  ImageUploader.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 01.09.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit
import AssetsLibrary
import AmazonS3RequestManager

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if widthFactor > heightFactor {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}

class ImageUploader {
    
    func uploadImage(url: URL?, callback: @escaping ()->Void) {
        if let actualMediaURL = url {
            var fileName = "temp.jpg"
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.asset(for: actualMediaURL , resultBlock: { asset in
                if let actualAsset = asset as ALAsset? {
                    let assetRep: ALAssetRepresentation = actualAsset.defaultRepresentation()
                    fileName = assetRep.filename()
                    let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                    let image = UIImage(cgImage: iref)
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                    let documentsDir = paths.firstObject as! NSString?
                    if let documentsDirectory = documentsDir {
                        let localFilePath = documentsDirectory.appendingPathComponent(fileName)
                        
                        let data = UIImageJPEGRepresentation(image.resizedImageWithinRect(rectSize: CGSize(width: 400, height: 400)), 0.1)
                        _ = (try? data!.write(to: URL(fileURLWithPath: localFilePath), options: [.atomic])) != nil
                        let localFileURL = URL(fileURLWithPath: localFilePath)
                        let amazonS3Manager = AmazonS3RequestManager(bucket: "imageeditor", region: .custom(hostName: "rest.s3for.me", endpoint: "rest.s3for.me"), accessKey: "67AA909CA1A9FCE6D8FEE5655B0A1031", secret: "9e5bc76d28ec4c07e91cc1bef877f09005d46ea5")
                        let ticks = Date().ticks
                        let uploadRequest = amazonS3Manager.upload(from: localFileURL, to: "userimages/\(ticks).jpg")
                        
                        uploadRequest.uploadProgress(queue: DispatchQueue.main, closure: { (progress) in
                            print("\(progress.totalUnitCount) \(progress.completedUnitCount) \(progress.fractionCompleted)")
                            if progress.fractionCompleted == 1.0 {
                                let postService = PostsService()
                                postService.createPost(imageUrl: "http://rest.s3for.me/imageeditor/userimages/\(ticks).jpg", name: "Test")
                                
                                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                                    let post = PostModel(context: appDelegate.persistentContainer.viewContext)
                                    post.imageUrl = "http://rest.s3for.me/imageeditor/userimages/\(ticks).jpg"
                                    post.name = "Test"
                                    appDelegate.saveContext()
                                    callback()
                                }
                            }
                        })
                        
                        
                    }
                }
            }, failureBlock: { (error) -> Void in
                
            })
        }

    }
    
}
