//
//  DetailViewController.swift
//  SimpleTableView
//
//  Created by apple on 18/7/2017.
//  Copyright © 2017 greatwall. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SDWebImage
import SwiftyJSON
import SVProgressHUD

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var passShop: Shop?
    var flag = false
    
    @IBOutlet weak var shopImageView: UIImageView!
    
    @IBOutlet weak var shopInfoLabel: UILabel!

    @IBOutlet weak var favoritesButton: UIButton! {
        didSet {
            favoritesButton.setTitle("Favorites", for: UIControlState.normal)
        }
    }
 
    @IBOutlet weak var tableView: UITableView!
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        favoritesButton.setTitle("Favorited", for: UIControlState.normal)
        favoritesButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        favoritesButton.backgroundColor = UIColor.red
        
        container?.performBackgroundTask({ (context) in
            _ = try? MyShop.findOrCreateShop(matching: self.passShop!, in: context)
        })
    }

    var menu = [Dictionary<String, [String]>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if flag {
            favoritesButton.isEnabled = false
            favoritesButton.setTitle("Favorited", for: UIControlState.normal)
        } else {
            favoritesButton.isEnabled = true
        }
        
        let titleName = (passShop?.shopName)!
        print(titleName)
        if let match = titleName.range(of: "^.+(?=\\()", options: .regularExpression) {
            navigationItem.title = titleName.substring(with: match)
        } else {
            navigationItem.title = titleName
        }
        
        setShopInfo(with: passShop!)
        
        setMenuInfo()
    }
    
    private func setMenuInfo() {
        
        SVProgressHUD.show()
        
        let url = URL(string: "https://api.doordash.com/v2/restaurant/9/menu/")
        Alamofire.request(url!).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                
                for (_, subJson):(String, JSON) in json {
                    
                    var saveMenu = Dictionary<String, [String]>()
                    var categoryName = [String]()

                    var name = subJson["name"].stringValue
                    if let match = name.range(of: "(?<=\\()[^\\)]+", options: .regularExpression) {
                        name = name.substring(with: match)
                    }
                    
                    for (_, subsub):(String, JSON) in subJson["menu_categories"] {
                        categoryName.append(subsub["title"].stringValue)
                    }
                    saveMenu[name] = categoryName
                    self.menu.append(saveMenu)
                }
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            case.failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func setShopInfo(with shopInfo: Shop) {
        
        let imageURL = URL(string: shopInfo.shopImage)
        
        shopImageView.sd_setImage(with: imageURL!)
        
        var price: String {
            if shopInfo.shopPrice != 0 {
                return String(format: "$%.2f delivery", shopInfo.shopPrice)
            } else {
                return "Free delivery"
            }
            
        }
        shopInfoLabel.text = String(format: "%@ in %d min", price, shopInfo.shopTime)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dict = menu[section]
        var name = String()
        for key in dict.keys {
            name = key
        }
        return name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict = menu[section]
        var num = 0
        for array in dict.values {
            num = array.count
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let dict = menu[indexPath.section]
        for array in dict.values {
            cell.textLabel?.text = array[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
