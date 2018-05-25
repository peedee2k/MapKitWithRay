//
//  DetailVC.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 5/22/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class DetailVC: UIViewController {
    
    let cellIDForMenu = "ShowMenu"

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var restInfo: RestaurantInfo?
    var logo = ""
   
    var menuArray = [RestaurantInfo]()
    var catList = [String]()
   
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = restInfo?.restName
        let image = restInfo?.restImage
        let url = URL(string: image!)
       logoImage.downloadedFrom(url: url!)
        catList = (restInfo?.tags)!
        let timeleft = restInfo?.time!
        deliveryTimeLabel.text = ("Delivery in \(timeleft!) min")
        guard let id = restInfo?.id else { return }
        
        getMenuData(url: "https://api.doordash.com/v2/restaurant/\(id)/menu/")
    }
    
     var newResult:JSON = JSON.null
    
    
    func getMenuData(url: String) {
       
       
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
              
                self.newResult = data
                
                for i in 0..<self.newResult.count {
                    let result = Menu(menuDict: self.newResult[i])
                    self.catList = result.category!
                   
                }
               
            }
        
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
    }
        
    }
    

}

extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIDForMenu, for: indexPath)
        cell.textLabel?.text = catList[indexPath.row]
        return cell
    }
}
