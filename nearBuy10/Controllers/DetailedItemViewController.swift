//
//  DetailedItemViewController.swift
//  nearBuy10
//
//  Created by Jim on 3/29/21.
//

import UIKit
import CoreData


class DetailedItemViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var detailItemNameLabel: UILabel!
    @IBOutlet weak var detailItemImageView: UIImageView!
    @IBOutlet weak var detailItemStoreList: UITableView!
    
    var selectedItem : Item?
    var storeArray : [Store]?
    var itemArray : [Item]?
    var selectedItemStoreArray : [Store]?
    //var detailItem : Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetails()
        detailItemNameLabel.text = selectedItem?.itemName
        print("In the Detailed View Controller, the Selected Item's stores are  \(selectedItemStoreArray)")
        title = selectedItem?.itemName
        
        detailItemStoreList.delegate = self
        detailItemStoreList.dataSource = self
        detailItemStoreList.allowsMultipleSelection = true
        detailItemStoreList.allowsMultipleSelectionDuringEditing = true
        loadItems()
        loadStores()
        //loadDetailedStores()
        //selectedItemStoreArray = (selectedItem!.stores!.allObjects as! [Store])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray?.count ?? 0
        //        return selectedItemStoreArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailItemStoreList.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! UITableViewCell
        
        //cell.textLabel?.text = selectedItemStoreArray?[indexPath.row].storeName
        cell.textLabel?.text = storeArray?[indexPath.row].storeName
        
        let storeToCheck = (storeArray?[indexPath.row])!
        if selectedItemStoreArray!.contains(storeToCheck) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if detailItemStoreList.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            detailItemStoreList.cellForRow(at: indexPath)?.accessoryType = .none
            if let detailStore = self.selectedItemStoreArray?[indexPath.row] {
                self.selectedItemStoreArray = self.storeArray?.filter { $0.storeName != detailStore.storeName }
            }
        } else {
            detailItemStoreList.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.selectedItemStoreArray?.append(self.storeArray![indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        print(selectedItemStoreArray)
        saveItem()
    }
    
    
    func fetchDetails(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        let predicate = NSPredicate(format: "item == %@" , selectedItem as! CVarArg )
        request.predicate = predicate
        selectedItemStoreArray = selectedItem?.stores?.allObjects as! [Store]
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Save and Load Functions
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error saving stores \(error)")
        }
        
    }
    
    
    //LoadItems using Search Request Only
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
    func loadStores() {
        let request : NSFetchRequest<Store> = Store.fetchRequest()
        do {
            storeArray = try context.fetch(request)
        } catch {
            print("Error loading Stores \(error)")
        }
        
    }
    
    
}
