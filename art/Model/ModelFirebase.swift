//
//  ModelFirebase.swift
//  art
//
//  Created by Itamar Marom on 08/06/2021.
//

import Foundation
import Firebase

class ModelFirebase {
    init() {
        FirebaseApp.configure()
    }
    
    func getAllItems(callback:@escaping ([Item])->Void){
        let db = Firestore.firestore()
        db.collection("items").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
              } else {
                if let snapshot = snapshot {
                    var items = [Item]()
                    for snap in snapshot.documents {
                        if let item = Item.create(json: snap.data()) {
                            items.append(item)
                        }
                    }
                    callback(items)
                    return
                }
              }
            callback([Item]())
        }
    }
    
    func add(item:Item, callback:@escaping ()->Void) {
        let db = Firestore.firestore()
        db.collection("items").document(item.id ?? "1").setData(item.toJson()){ err in
            if let err = err {
              print("Error writing document: \(err)")
            } else {
                print("document successfully writen")
            }
            callback()
        }
    }
    
    func delete(item:Item, callback:@escaping ()->Void) {
        let db = Firestore.firestore()
        db.collection("items").document("1").delete(){ err in
            if let err = err {
              print("Error writing document: \(err)")
            } else {
                print("document successfully writen")
            }
            callback()
        }
    }
    
    func getItem(byId: String)->Item?{
        
        return nil
    }
}
