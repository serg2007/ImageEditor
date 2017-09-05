//
//  ImageCreatorVC.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 31.08.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit
import AmazonS3RequestManager
import AssetsLibrary
// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

class ImageCreatorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mainImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addImageTap(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        show(imagePicker, sender: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) {
            self.mainImage.image = image
        }
        
        
        var refURL = info[UIImagePickerControllerReferenceURL] as! URL?;
        if refURL == nil {
            refURL = info[UIImagePickerControllerMediaURL] as! URL?;
        }
        
        let imageUploader = ImageUploader()
        imageUploader.uploadImage(url: refURL) {
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
            
    }
    
}
