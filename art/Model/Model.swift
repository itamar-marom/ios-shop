//
//  Model.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//

import Foundation
import UIKit
import CoreData

class NotificationGeneral{
    let name:String
    init(_ name: String){
        self.name = name
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(name), object: self)
    }

    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(name), object: self, queue: nil) { (notification) in
            callback()
        }
    }
}

class Model {
    static let instance = Model()
    
    public let notificationItemList = NotificationGeneral("notificationItemList")
    
    private init(){}
    
    let modelFirebase = ModelFirebase()
    
    func getAllItems(callback:@escaping ([Item])->Void){
        // get last update date
        let lastUpdateDate:Int64 = Item.getLastUpdate()
        // get all updated records from firebase
        modelFirebase.getAllItems(since: lastUpdateDate) { (items) in
            var lastUpdate:Int64 = 0
            for item in items{
                print("item \(item.lastUpdated)")
                if (lastUpdate < item.lastUpdated){
                    lastUpdate = item.lastUpdated
                }
//                print("getting itemsss from Modelllllllllllll ", items)
//                print(item.id, item.delFlag)
//                if item.delFlag{
//                    print("will delete from local ", item.id)
//                    item.delete()
//                }
            }
            //update the local last update date
            Item.saveLastUpdate(time: lastUpdate)
            //save context in local db
            if items.count > 0 {items[0].save()}
            
            //read the complete students list from the local DB
            Item.getAll(callback: callback)
        }
    }
    
    func add(item:Item, callback:@escaping ()->Void) {
        modelFirebase.add(item: item){
            callback()
            self.notificationItemList.post()
        }
    }
    
    func delete(item:Item, callback:@escaping ()->Void) {
        item.delFlag = true
//        modelFirebase.add(item: item){
//            callback()
//            self.notificationItemList.post()
//        }
        
        
        modelFirebase.delete(item: item){
            callback()
            self.notificationItemList.post()
        }
        item.delete()
        
    }
    
    func update(item:Item, callback:@escaping ()->Void) {
        modelFirebase.update(item: item){
            callback()
            self.notificationItemList.post()
        }
    }
    
    func getItem(byId: String)->Item?{
        return nil
    }
    
    func saveImage(image:UIImage, callback:@escaping (String)->Void){
        ModelFirebase.saveImage(image: image, callback: callback)
    }
}
