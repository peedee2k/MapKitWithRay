//
//  Menu.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 5/25/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class Menu {
    
    let name: String?
    let category: [String]?
    
    init(menuDict: JSON) {
        let name = menuDict["name"].stringValue
        self.name = name
        let categoryList = menuDict["menu_categories"].arrayObject
        var catList = [String]()
        for category in categoryList! {
            let cate = category as! [String: Any]
            let list = cate["title"] as! String
            catList.append(list)
        }
        self.category = catList
            }
}
