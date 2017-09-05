//
//  ImageDownloader.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 01.09.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImage(url: URL, callBack: @escaping ()->Void) {
        
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
                callBack()
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Do something with your image.
                        DispatchQueue.main.async {
                            self.image = UIImage(data: imageData)
                        }
                        callBack()
                    } else {
                        print("Couldn't get image: Image is nil")
                        callBack()
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    callBack()
                }
            }
        }
        downloadPicTask.resume()
    }
}
