//
//  RestaurantInfo.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 5/20/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestaurantInfo {
    let id: Int?
    let restName: String?
    let restType: String?
    let deliveryCharge: Double?
    let restImage: String?
    let time: Int?
    let tags: [String]?
    init(dict: JSON) {
        let restID = dict["id"].intValue
        self.id = restID
        let description = dict["description"].stringValue
        self.restType = description
        let business = dict["business"].dictionaryObject
        let name = business!["name"]
        self.restName = name as? String
        let coverImage = dict["cover_img_url"].stringValue
        self.restImage = coverImage
        let delivery = dict["delivery_fee"].doubleValue
        self.deliveryCharge = delivery
        let deliveryTime = dict["asap_time"].intValue
        self.time = deliveryTime
        let menuTags = dict["tags"].arrayObject
        self.tags = menuTags as? [String]
    }
    
}
