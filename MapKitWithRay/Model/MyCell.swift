//
//  MyCell.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 5/21/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    @IBOutlet weak var restName: UILabel!
    
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var restType: UILabel!
    
    @IBOutlet weak var deliveryLabel: UILabel!
    
    @IBOutlet weak var deliveryTime: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setConstrains() {
//        restImage.translatesAutoresizingMaskIntoConstraints = false
//        restImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        restImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
//        restImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
//        restImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        
//        restName.translatesAutoresizingMaskIntoConstraints = false
//        restName.topAnchor.constraint(equalTo: restImage.topAnchor).isActive = true
//        restName.leftAnchor.constraint(equalTo: restImage.trailingAnchor, constant: 15).isActive = true
//        restName.trailingAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
//        restName.heightAnchor.constraint(equalToConstant: 15).isActive = true
//    }

}
