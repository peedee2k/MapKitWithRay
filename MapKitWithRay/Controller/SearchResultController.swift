//
//  SearchResultController.swift
//  MapKitWithRay
//
//  Created by Pankaj Sharma on 5/18/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SearchResultController: UIViewController {
    
    struct SetUp {
       static let redColour = UIColor(red: 252/255, green: 33/255, blue: 70/255, alpha: 1)
    }
    
    let cellID = "cellID"
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.showsVerticalScrollIndicator = false
       // navigationItem.title = "Door Dash"
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        titleLabel.text = "Door Dash"
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(20)
        titleLabel.textColor = SetUp.redColour
        navigationItem.titleView = titleLabel
        
    
       
        
        let searchImage = UIImage(named: "nav-search")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor(red: 252/255, green: 33/255, blue: 70/255, alpha: 1)
        getData(url: "https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956")
       
    }
    
    
   
    
    @objc func searchButtonTapped() {
        
    }
    var myresult:JSON = JSON.null
    var dataArray = [RestaurantInfo]()
    var menu = [String]()
    func getData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
               self.myresult = data
                
                for i in 0..<self.myresult.count {
                   let result = RestaurantInfo(dict: self.myresult[i])
                    self.dataArray.append(result)
                    
                    
                }
               
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
                
            
                
                
            }
        }
    }
    
}
extension SearchResultController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MyCell
        let photoURL = dataArray[indexPath.row].restImage
        let url = URL(string: photoURL!)
        cell.restImage.downloadedFrom(url: url!) 
        cell.restName.text = dataArray[indexPath.row].restName
        cell.restType.text = dataArray[indexPath.row].restType
        let delivery = (dataArray[indexPath.row].deliveryCharge!)
        var displayCharges = ""
        
        if delivery == 0.0 {
            displayCharges = "Free Delivery"
        } else { displayCharges = "$\(dataArray[indexPath.row].deliveryCharge!) Delivery Charges"
        }
        cell.deliveryLabel.text = displayCharges
        let delivrytime = (dataArray[indexPath.row].time!)
        
        var time = ""
        
        if delivrytime == 0 {
            time = ""
        } else {
            time = "\(dataArray[indexPath.row].time!) min"
        }
        cell.deliveryTime.text = time
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
       
        performSegue(withIdentifier: "detailVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let detailVC = segue.destination as? DetailVC
            detailVC?.restInfo = dataArray[(myTableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
