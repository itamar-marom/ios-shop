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
import Firebase

@objc(Item)
public class Item: NSManagedObject {
    static func create(item:Item)->Item{
        return create(id: item.id!, name: item.name!, size: item.size!, price: item.price!, image: item.image!,lastUpdated: item.lastUpdated, delFlag: item.delFlag)
    }
    
    static func create(id: String, name: String, size:String, price:String, image:String, lastUpdated:Int64, delFlag:Bool)->Item{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Item(context: context)
        item.id = id
        item.name = name
        item.size = size
        item.price = price
        item.image = image
        item.lastUpdated = lastUpdated
        item.delFlag = delFlag
        return item
    }
    
    static func create(json:[String:Any])->Item?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Item(context: context)
        item.id = json["id"] as? String
        item.name = json["name"] as? String
        item.size = json["size"] as? String
        item.price = json["price"] as? String
        item.image = json["image"] as? String
        item.lastUpdated = 0
        if let timestamp = json["lastUpdated"] as? Timestamp {
            item.lastUpdated = timestamp.seconds
        }
        item.delFlag = false
        if let df = json["delFlag"] as? Bool {
            item.delFlag = df
        }
        return item
    }
    
    func toJson()->[String:Any] {
        var json = [String:Any]()
        json["id"] = id!
        json["name"] = name!
        json["size"] = size!
        json["price"] = price!
//        json["image"] = image!
        if let image = image {
            json["image"] = image
        } else {
            json["image"] = ""
        }
        json["lastUpdated"] = FieldValue.serverTimestamp()
        json["delFlag"] = delFlag
        return json
    }
    
    static func saveLastUpdate(time:Int64){
        UserDefaults.standard.set(time, forKey: "lastUpdate")
    }
    static func getLastUpdate()->Int64{
        return Int64(UserDefaults.standard.integer(forKey: "lastUpdate"))
    }
}

extension Item{
    static func getAll(callback:@escaping ([Item])->Void){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        DispatchQueue.global().async {
            //second thread code
            var data = [Item]()
            do{
                data = try context.fetch(request)
            }catch{
            }
            
            DispatchQueue.main.async {
                // code to execute on main thread
                callback(data)
            }
        }
    }
    
    func save(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do{
            try context.save()
        }catch{
            
        }
    }
    
    func addItemToLocalDb(){
        let item = Item.create(item: self)
        item.save()
    }
    
    func delete(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(self)
        do{
            try context.save()
        }catch{
            
        }
    }
    
    static func getItem(byId:String)->Item?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let request = Item.fetchRequest() as NSFetchRequest<Item>
        request.predicate = NSPredicate(format: "id == \(byId)")
        do{
            let items = try context.fetch(request)
            if items.count > 0 {
                return items[0]
            }
        }catch{
            
        }
        return nil
    }
}


