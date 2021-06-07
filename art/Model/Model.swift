//
//  Model.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//

import Foundation
import UIKit
import CoreData

class Model {
    static let instance = Model()
    
    private init(){}
    
    var items = [Item]()
    
    func getAllItems()->[Item] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let item = try context.fetch(Item.fetchRequest()) as! [Item]
            return item
        } catch {
            return [Item]()
        }
    }
    
    func add(item:Item) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func delete(item:Item) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(item)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func getItem(byId: String)->Item?{
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
