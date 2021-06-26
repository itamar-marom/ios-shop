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
    
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var size: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var delFlag: Bool
    @NSManaged public var userId: String?
    @NSManaged public var email: String?

} 
