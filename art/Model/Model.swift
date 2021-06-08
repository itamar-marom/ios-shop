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
        
    }
    
    func add(item:Item) {
        
    }
    
    func delete(item:Item) {
        
    }
    
    func getItem(byId: String)->Item?{
        
        return nil
    }
}
