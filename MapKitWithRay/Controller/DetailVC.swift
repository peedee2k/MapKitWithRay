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

protocol FavResturantSelection {
    func chooseFavRest(btnState: Bool)
}

class DetailVC: UIViewController {
    
    let cellIDForMenu = "ShowMenu"
    
    var favBtnDelegate: FavResturantSelection?
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var detailTableView: UITableView!
    var restInfo: RestaurantInfo?
    let btnKey = "btnKey"
    
    
    
    var catList = [String]()
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
       
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = restInfo?.restName
        setUpBackButton()
        favButtonSetup()
        tabBarSetUp()
        setRestValue()
        userDefaultShowValue()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // userDefaultShowValue()
        toggleFavBtn()
    }
    
    func userDefaultShowValue() {
        if restInfo?.selectedButton == true {
            favoriteButton.isSelected = UserDefaults.standard.bool(forKey: btnKey)
        }
    }
    
    func userDefaultSetValue() {
        if restInfo?.selectedButton == true {
            UserDefaults.standard.set(restInfo?.selectedButton, forKey: btnKey)
            }
    }
    
    
    func setUpBackButton() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        navigationItem.leftBarButtonItem = backButton
        
    }
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        restInfo?.selectedButton = favoriteButton.isSelected
        
        favBtnDelegate?.chooseFavRest(btnState: (restInfo?.selectedButton)!)
        userDefaultSetValue()
        navigationController?.popViewController(animated: true)
        
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
        UITabBar.appearance().tintColor = General.redColour
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
                self.detailTableView.reloadData()
                }
            }
        }
    
    
    
    func favButtonSetup() {
        favoriteButton.layer.borderWidth = 3
        favoriteButton.layer.borderColor = General.redColour.cgColor
        favoriteButton.layer.cornerRadius = 5
        favoriteButton.layer.masksToBounds = true
        favoriteButton.setTitle("Add to Favorite", for: UIControl.State.normal)
        favoriteButton.setImage(nil, for: UIControl.State.normal)
        favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        favoriteButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
        favoriteButton.backgroundColor = UIColor.white
    }
    
   
    @IBAction func favoriteBtnTapped(_ sender: UIButton) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        toggleFavBtn()
        }
    
    func toggleFavBtn() {
        if favoriteButton.isSelected == true {
            favoriteButton.setImage(UIImage(named: "star-white"), for: UIControl.State.normal)
            favoriteButton.tintColor = UIColor.white
            favoriteButton.setTitle("Favorited", for: UIControl.State.normal)
            favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            favoriteButton.backgroundColor = General.redColour
            favoriteButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        } else {
           favoriteButton.setTitle("Add to Favorite", for: UIControl.State.normal)
            favoriteButton.setImage(nil, for: UIControl.State.normal)
            favoriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            favoriteButton.setTitleColor(UIColor.red, for: UIControl.State.normal)
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
