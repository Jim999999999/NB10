//
//  ShoppingTableViewController.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {


    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    var shoppingArray = [Item]() //subset of Items specific to this store
    var purchaseArray = [Item]()
    
    var selectedItem : Item?
    var selectedStore : Store? {
        didSet{
            loadShopping()
        }
    }
 
    var shoppingLabel : Store?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedStore?.storeName

        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        cell.textLabel?.text = shoppingArray[indexPath.row].itemName
        cell.accessoryType = .checkmark

        return cell
    }

    // Select Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shoppingArray[indexPath.row].needed = !shoppingArray[indexPath.row].needed
        purchaseArray.append(shoppingArray[indexPath.row])
    }
    
    // DEselect Row
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        purchaseArray.remove(at: indexPath.row)
    }
 
    @IBAction func buyButtonPressed(_ sender: Any) {
        print(purchaseArray)
        updateItemList()
        saveItem()
    }
    

    
    
    
    func updateItemList() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let updateResults = try context.fetch(request)
            for item in updateResults {
                if purchaseArray.contains(item) {
                    item.needed = false
                }
            }
            saveItem()
            
        } catch {
            
        }
    }
    


    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error saving Item \(error)")
        }
    }
    
    
    func saveShopping() {

        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }

        self.tableView.reloadData()
    }
    
    
    
    func loadShopping(with request: NSFetchRequest<Item> = Item.fetchRequest(), storePredicate: NSPredicate? = nil) //, needPredicate: NSPredicate? = nil) {
        {
        let storePredicate = NSPredicate(format: "ANY stores.storeName = %@", selectedStore?.storeName as! CVarArg)
        
        let needPredicate = NSPredicate(format: "needed == true")
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [storePredicate, needPredicate])
        
        request.predicate = compoundPredicate
        
        do {
            shoppingArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
 }

 //MARK: - Search bar methods

// extension ItemTableViewController: UISearchBarDelegate {
//
//     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//         let request : NSFetchRequest<Item> = Item.fetchRequest()
//         let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
//
//         request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
//         request.predicate = predicate
//
//         loadItems(with: request, predicate: predicate)
//     }
//
//     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//         if searchBar.text?.count == 0 {
//             loadItems()
//             DispatchQueue.main.async {
//                 searchBar.resignFirstResponder()
//             }
//         }
//     }
//
// }
