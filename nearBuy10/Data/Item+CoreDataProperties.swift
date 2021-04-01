//
//  Item+CoreDataProperties.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//
//

import Foundation
import CoreData
import UIKit


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemName: String
    @NSManaged public var itemImage: Data?
    @NSManaged public var needed: Bool
    @NSManaged public var stores: NSSet?

}

// MARK: Generated accessors for stores
extension Item {

    @objc(addStoresObject:)
    @NSManaged public func addToStores(_ value: Store)

    @objc(removeStoresObject:)
    @NSManaged public func removeFromStores(_ value: Store)

    @objc(addStores:)
    @NSManaged public func addToStores(_ values: NSSet)

    @objc(removeStores:)
    @NSManaged public func removeFromStores(_ values: NSSet)

}

extension Item : Identifiable {

}
