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
        modelFirebase.getAllItems(callback: callback)
    }
    
    func add(item:Item, callback:@escaping ()->Void) {
        modelFirebase.add(item: item){
            callback()
            self.notificationItemList.post()
        }
    }
    
    func delete(item:Item, callback:@escaping ()->Void) {
        modelFirebase.delete(item: item){
            callback()
            self.notificationItemList.post()
        }
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
}
