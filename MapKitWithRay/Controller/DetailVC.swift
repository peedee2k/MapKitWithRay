//
//  DetailVC.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 5/22/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit


class DetailVC: UIViewController {
    
    let cellIDForMenu = "ShowMenu"

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var restInfo: RestaurantInfo?
    var logo = ""
   
    var menuArray = [RestaurantInfo]()
    var catList = [String]()
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
