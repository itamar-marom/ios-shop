//
//  Item+CoreDataClass.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//
//

import Foundation
import CoreData
import UIKit

@objc(Item)
public class Item: NSManagedObject {
    
    static func create(id: String, name: String, size:String, price:String)->Item{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Item(context: context)
        item.id = id
        item.name = name
        item.size = size
        item.price = price
        return item
    }
    
    static func create(json:[String:Any])->Item?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Item(context: context)
        item.id = json["id"] as? String
        item.name = json["name"] as? String
        item.size = json["size"] as? String
        item.price = json["price"] as? String
        return item
    }
    
    func toJson()->[String:Any] {
        var json = [String:Any]()
        json["id"] = id!
        json["name"] = name!
        json["size"] = size!
        json["price"] = price!
//        if let image = image {
//            json["image"] = image
//        } else {
//            json["image"] = ""
//        }
        return json
    }
}
