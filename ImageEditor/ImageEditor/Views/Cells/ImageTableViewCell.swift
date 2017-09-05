//
//  ImageTableViewCell.swift
//  ImageEditor
//
//  Created by Sergiy Sobol on 10.08.17.
//  Copyright © 2017 Sergiy Sobol. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var backImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func paralaxMove(tableView: UITableView) {
        let delta = (self.frame.origin.y - tableView.contentOffset.y) / tableView.frame.height
        
        backImageTopConstraint.constant = -delta * 100
        
        print(delta)
        print("\(tableView.contentOffset.y) \(self.frame.origin.y)")
    }
    
}
