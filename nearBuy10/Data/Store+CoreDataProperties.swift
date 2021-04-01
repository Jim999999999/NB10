//
//  Store+CoreDataProperties.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//
//

import Foundation
import CoreData
import UIKit

extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var storeName: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Store {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Store : Identifiable {

}
