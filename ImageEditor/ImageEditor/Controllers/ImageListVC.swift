//
//  ImageListVC.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 10.08.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit

class ImageListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var images: [ImageModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [ImageModel(name: "saf", imageName: "priroda_1"), ImageModel(name: "saf", imageName: "priroda_2"), ImageModel(name: "saf", imageName: "priroda_3"), ImageModel(name: "saf", imageName: "priroda_4"), ImageModel(name: "saf", imageName: "priroda_5")]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
        let imageModel = images?[indexPath.row]
        
        cell.mainImage.image = UIImage(named: (imageModel?.imageName)!)
        cell.nameLbl.text = imageModel?.name
        
        let delta = (cell.frame.origin.y - tableView.contentOffset.y) / tableView.frame.height
        
        cell.backImageTopConstraint.constant = -delta * 100
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.visibleCells.forEach { (cell) in
            (cell as! ImageTableViewCell).paralaxMove(tableView: tableView)
        }
    }

}
