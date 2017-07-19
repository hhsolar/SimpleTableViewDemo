//
//  ItemTableViewCell.swift
//  SimpleTableView
//
//  Created by apple on 18/7/2017.
//  Copyright © 2017 greatwall. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var shopImageView: UIImageView!

    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    
    @IBOutlet weak var shopPriceLabel: UILabel!
    
    @IBOutlet weak var shopTimeLabel: UILabel!
    
    public func updateCell(with shop: Shop) {
        let imageURL = URL(string: shop.shopImage)
        
        shopImageView.sd_setImage(with: imageURL!)
        
        shopNameLabel.text = shop.shopName
        shopDescriptionLabel.text = shop.shopDiscription
        if shop.shopPrice != 0 {
            shopPriceLabel.text = String(format: "$%.2f delivery", shop.shopPrice)
        } else {
            shopPriceLabel.text = "Free delivery"
        }
        shopTimeLabel.text = String(format: "%d min", shop.shopTime)
    }
    
}
