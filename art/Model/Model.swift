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
    
    let modelFirebase = ModelFirebase()
    
    func getAllItems(callback:@escaping ([Item])->Void){
        modelFirebase.getAllItems(callback: callback)
    }
    
    func add(item:Item) {
        modelFirebase.add(item: item)
    }
    
    func delete(item:Item) {
        modelFirebase.delete(item: item)
    }
    
    func getItem(byId: String)->Item?{
        
        return nil
    }
}
