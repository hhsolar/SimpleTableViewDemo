//
//  ExploreTableViewController.swift
//  SimpleTableView
//
//  Created by apple on 18/7/2017.
//  Copyright © 2017 greatwall. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ExploreTableViewController: BaseTableViewController {
 
    var exploreCoordinate: CLLocationCoordinate2D?

    var shops = [Shop]()
    var matchShop = [Shop]()
    var searchFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "itemCell")
        
        loadData(with: exploreCoordinate!)
    }
    
    private func doorDashURL(with coordinate: CLLocationCoordinate2D) -> URL {
        let urlString = String(format: "https://api.doordash.com/v1/store_search/?lat=%@&lng=%@", String(coordinate.latitude), String(coordinate.longitude))
        return URL(string: urlString)!
    }
    
    private func loadData(with coordinate: CLLocationCoordinate2D) {
        let url = doorDashURL(with: coordinate)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                for (_, subJson):(String, JSON) in json {
                    let id = subJson["id"].int32Value
                    let name = subJson["name"].stringValue
                    let description = subJson["description"].stringValue
                    let price = subJson["delivery_fee"].floatValue
                    let time = subJson["asap_time"].int32Value
                    let image = subJson["cover_img_url"].stringValue
                    let shopItem = Shop(shopImage: image, shopName: name, shopDiscription: description, shopPrice: price, shopTime: time, shopID: id)
                    self.shops.append(shopItem)
                }
                self.tableView.reloadData()
            case.failure(let error):
                print("\(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = segue.destination.content as! DetailViewController
            let indexPath = sender as! IndexPath
            if searchFlag {
                controller.passShop = matchShop[(indexPath.row)]
            } else {
                controller.passShop = shops[(indexPath.row)]
            }
            controller.flag = false
        }
    }
    
    // MARK: SearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if shops.count == 0 {
            return
        }
        
        if let text = searchBar.text {
            if text.characters.count > 0 {
                matchShop.removeAll()
                for item in shops {
                    if item.shopName.contains(text) {
                        matchShop.append(item)
                    }
                }
                searchFlag = true
            } else {
                searchFlag = false
            }
            tableView.reloadData()
        }
    }

}

extension ExploreTableViewController {
    
    // MARK: TableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchFlag {
            return shops.count
        } else {
            return matchShop.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        if !searchFlag {
            cell.updateCell(with: shops[indexPath.row])
        } else {
            cell.updateCell(with: matchShop[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

