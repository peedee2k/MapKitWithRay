//
//  CellXIB.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 6/19/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

class CellXIB: UITableViewCell {
    
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var restNameLbl: UILabel!
    @IBOutlet weak var restTypeLbl: UILabel!
    @IBOutlet weak var deliveryFeeLbl: UILabel!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
