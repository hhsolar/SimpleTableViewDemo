//
//  MyShop.swift
//  SimpleTableView
//
//  Created by apple on 18/7/2017.
//  Copyright © 2017 greatwall. All rights reserved.
//

import UIKit
import CoreData

class MyShop: NSManagedObject {

    class func findOrCreateShop(matching shopInfo: Shop, in context: NSManagedObjectContext) throws -> MyShop
    {
        let request: NSFetchRequest<MyShop> = MyShop.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", shopInfo.shopID)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0{
                assert(matches.count > 1, "Shop.findOrCreateShop -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        let shop = MyShop(context: context)
        shop.id = shopInfo.shopID
        shop.name = shopInfo.shopName
        shop.shopDescription = shopInfo.shopDiscription
        shop.price = shopInfo.shopPrice
        shop.time = shopInfo.shopTime
        shop.image = shopInfo.shopImage
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        return shop
    }
    
    class func convertMyShopToShop(_ myshop: MyShop) -> Shop {
        let id = myshop.id
        let name = myshop.name
        let discription = myshop.shopDescription
        let price = myshop.price
        let time = myshop.time
        let imageString = myshop.image
        return Shop(shopImage: imageString!, shopName: name!, shopDiscription: discription!, shopPrice: price, shopTime: time, shopID: id)
    }
    
}
