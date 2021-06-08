//
//  Item+CoreDataProperties.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//
//

import Foundation
import CoreData
import UIKit

extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var size: String?

}

//extension Item : Identifiable {
extension Item {

    static func getAll(callback:@escaping ([Item])->Void){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        DispatchQueue.global().async {
            
            var data = [Item]()
            do {
                data = try context.fetch(Item.fetchRequest()) as! [Item]
            } catch {
            }
            
            DispatchQueue.main.async {
                callback(data)
            }
        }
    }
    
    func save() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func delete() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(self)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    static func getItem(byId: String)->Item?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        request.predicate = NSPredicate(format: "id == \(byId)")
        do {
            let items = try context.fetch(request)
            if items.count > 0 {
                return items[0]
            }
        } catch {
            
        }
        return nil
    }
}
