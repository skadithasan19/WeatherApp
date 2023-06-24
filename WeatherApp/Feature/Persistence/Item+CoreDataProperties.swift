//
//  Item+CoreDataProperties.swift
//  CoredataTest
//
//  Created by Adit Hasan on 6/23/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Item : Identifiable {

}
