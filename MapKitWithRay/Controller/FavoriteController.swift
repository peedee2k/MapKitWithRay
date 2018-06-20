//
//  FavoriteController.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 6/19/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController {
    
    
    var favRestArray = [RestaurantInfo]()
    @IBOutlet weak var FavTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: General.nibFileName, bundle: nil)
        FavTableView.register(nib, forCellReuseIdentifier: General.nibCell)
        
    }
    var newArray = [RestaurantInfo]()
    
    override func viewWillAppear(_ animated: Bool) {
        let favVC = self.tabBarController?.viewControllers![0] as! SearchResultController
        newArray = favVC.dataArray
        setUpCell()
        FavTableView.reloadData()
    }
    func setUpCell() {
        favRestArray.removeAll()
        for state in newArray {
            if state.selectedButton == true {
                favRestArray.append(state)
            }
        }
        FavTableView.reloadData()
    }
    

}

extension FavoriteController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favRestArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: General.nibCell, for: indexPath) as! CellXIB
        let photoURL = favRestArray[indexPath.row].restImage
        let url = URL(string: photoURL!)
        cell.restImage.downloadedFrom(url: url!)
        cell.restNameLbl.text = favRestArray[indexPath.row].restName
        cell.restTypeLbl.text = favRestArray[indexPath.row].restType
        let delivery = (favRestArray[indexPath.row].deliveryCharge!)
        var displayCharges = ""
        
        if delivery == 0.0 {
            displayCharges = "Free Delivery"
        } else { displayCharges = "$\(favRestArray[indexPath.row].deliveryCharge!) Delivery Charges"
        }
        cell.deliveryFeeLbl.text = displayCharges
        let delivrytime = (favRestArray[indexPath.row].time!)
        var time = ""
        
        if delivrytime == 0 { time = "" }
        else { time = "\(favRestArray[indexPath.row].time!) min" }
        cell.deliveryTimeLbl.text = time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
