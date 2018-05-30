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
    
    
    var catList = [String]()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = restInfo?.restName
        favButtonSetup()
        tabBarSetUp()
        saveFavBtn()
        setRestValue()
    }
    
    func setRestValue() {
        guard let image = restInfo?.restImage else { return }
        
        guard let url = URL(string: image) else { return }
        logoImage.downloadedFrom(url: url)
        
        guard let timeleft = restInfo?.time! else { return }
        deliveryTimeLabel.text = ("Delivery in \(timeleft) min")
        
        guard let id = restInfo?.id else { return }
        
        getMenuData(url: "https://api.doordash.com/v2/restaurant/\(id)/menu/")
    }
    
    func tabBarSetUp() {
        UITabBar.appearance().tintColor = ColorStruct.redColour
        tabBarController?.tabBar.isTranslucent = false
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
    
    func saveFavBtn() {
        
        
    }
    
    func favButtonSetup() {
        favoriteButton.layer.borderWidth = 3
        favoriteButton.layer.borderColor = ColorStruct.redColour.cgColor
        favoriteButton.layer.cornerRadius = 5
        favoriteButton.layer.masksToBounds = true
        
    }
    
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
    if favoriteButton.titleLabel?.text == "Add to Favorite" {
        favoriteButton.setImage(UIImage(named: "star-white"), for: .normal)
        favoriteButton.tintColor = UIColor.white
        favoriteButton.setTitle("Favorited", for: .normal)
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        favoriteButton.backgroundColor = ColorStruct.redColour
        favoriteButton.setTitleColor(UIColor.white, for: .normal)
    } else {
        favoriteButton.setTitle("Add to Favorite", for: .normal)
        favoriteButton.setImage(nil, for: .normal)
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        favoriteButton.setTitleColor(UIColor.red, for: .normal)
        favoriteButton.backgroundColor = UIColor.white
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
