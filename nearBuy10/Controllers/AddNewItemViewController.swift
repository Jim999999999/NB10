//
//  AddNewItemViewController.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//

import UIKit
import CoreData

class AddNewItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addNewItemTextField: UITextField!
    
    @IBOutlet weak var addStoresTableView: UITableView!
    
    //@IBOutlet weak var greenButton: UIButton
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray : [Item]?
    var storeArray : [Store]?
    var selectedStores = Array<Store>()
    var selected : [Store]?
    var greenButtonText = String()
    var titleText : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStoresTableView.delegate = self
        addStoresTableView.dataSource = self
        addStoresTableView.allowsMultipleSelection = true
        addStoresTableView.allowsMultipleSelectionDuringEditing = true
        loadStores()
        title = titleText
        
    }
        
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        print("Camera Button Pressed - still need to add code")
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addNewItem(addStores: selectedStores)
    }
    
    
    
    func addNewItem(addStores: Array<Store>) {
        let newItem = Item(context: self.context)
        newItem.itemName = addNewItemTextField.text ?? ""
        newItem.needed = true
        newItem.stores = NSSet(array: addStores)
        self.itemArray?.append(newItem)
        self.saveItem()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = addStoresTableView.dequeueReusableCell(withIdentifier: "addNewItemCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.storeArray?[indexPath.row].storeName

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if addStoresTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            addStoresTableView.cellForRow(at: indexPath)?.accessoryType = .none
            if let selctStore = self.storeArray?[indexPath.row] {
                self.selectedStores = self.selectedStores.filter { $0.storeName != selctStore.storeName }
                }
            } else {
            addStoresTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.selectedStores.append(self.storeArray![indexPath.row])
    
        }
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            if let selctStore = self.storeArray?[indexPath.row] {
                self.selectedStores = self.selectedStores.filter { $0.storeName != selctStore.storeName }
            }
        }
    }
    
    
    //MARK: - Save and Load functions

    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error saving Item \(error)")
        }
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error loading Items \(error)")
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

    


    
    

