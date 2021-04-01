//
//  Item+CoreDataClass.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//
//

import Foundation
import CoreData
import UIKit

@objc(Item)
public class Item: NSManagedObject {

    static let shared = Item()
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
}
