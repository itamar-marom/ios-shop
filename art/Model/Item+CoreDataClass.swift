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
    
    static func create(name: String, size:String)->Item{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Item(context: context)
        item.name = name
        item.size = size
        return item
    }
    
    static func create(json:[String:Any])->Item?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Item(context: context)
        item.name = json["name"] as? String
        item.size = json["size"] as? String
        return item
    }
    
    func toJson()->[String:Any] {
        var json = [String:Any]()
        json["name"] = name!
        json["size"] = size!
//        if let image = image {
//            json["image"] = image
//        } else {
//            json["image"] = ""
//        }
        return json
    }
}
