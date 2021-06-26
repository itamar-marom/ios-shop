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
    
    func getAllItems(since: Int64, callback:@escaping ([Item])->Void){
        let db = Firestore.firestore()
        db.collection("items")
            .order(by: "lastUpdated")
            .start(at: [Timestamp(seconds: since, nanoseconds: 0)])
            .getDocuments { (snapshot, err) in
            var items = [Item]()
            if let err = err{
                print("Error reading document: \(err)")
            }else{
                if let snapshot = snapshot{
                    for snap in snapshot.documents{
                        if let item = Item.create(json:snap.data()){
                            items.append(item)
                        }
                    }
                }
            }
            callback(items)
        }
    }
    
//    func getAllItems(callback:@escaping ([Item])->Void){
//        let db = Firestore.firestore()
//        db.collection("items").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error getting documents: \(error)")
//              } else {
//                if let snapshot = snapshot {
//                    var items = [Item]()
//                    for snap in snapshot.documents {
//                        if let item = Item.create(json: snap.data()) {
//                            items.append(item)
//                        }
//                    }
//                    callback(items)
//                    return
//                }
//              }
//            callback([Item]())
//        }
//    }
    
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
        db.collection("items").document(item.id ?? "1").delete(){ err in
            if let err = err {
              print("Error writing document: \(err)")
            } else {
                print("document successfully writen")
            }
            callback()
        }
    }
    
//    func update(item:Item, callback:@escaping ()->Void) {
//        let db = Firestore.firestore()
//        db.collection("items").document(item.id ?? "1").updateData(["name" : item.name, "size": item.size, "price": item.price, "image": item.image]){ err in
//            if let err = err {
//              print("Error writing document: \(err)")
//            } else {
//                print("document successfully writen")
//            }
//            callback()
//        }
//    }
    
    func getItem(byId: String)->Item?{
        return nil
    }
    
    static func saveImage(itemId: String, image:UIImage, callback:@escaping(String)->Void){
        let storageRef = Storage.storage().reference(forURL:
                                                        "gs://art-ios-27733.appspot.com/pic")
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child(itemId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    callback("")
                    return
                }
//                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
}
