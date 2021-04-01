//
//  Store+CoreDataClass.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//
//

import Foundation
import CoreData
import UIKit


@objc(Store)
public class Store: NSManagedObject {
    
    static let shared = Store()
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
