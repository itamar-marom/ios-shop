//
//  Product+CoreDataProperties.swift
//  art
//
//  Created by Itamar Marom on 07/06/2021.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?

}

extension Product : Identifiable {

}
