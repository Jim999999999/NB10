//
//  ItemTableViewController.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {

    var itemArray = [Item]()
    var storeArray = [Store]()
    var name: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var greenText = "Add"
    var addItemTitleText = "Add New Item"
    var detailedItem : Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ItemTableViewController.longPress(longPressGestureRecognizer:)))
            self.view.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @IBAction func unwindToItemView(sender: UIStoryboardSegue) {
        print("UnwindSegue pressed")
        saveItem()
        loadItems()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.itemName
        cell.accessoryType = item.needed ? .checkmark : .none
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].needed = !itemArray[indexPath.row].needed
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "goToDetailsSegue" else {return}
        let destinationVC = segue.destination as! DetailedItemViewController
        
        destinationVC.selectedItem = detailedItem
        
        
    }
        
       
    
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print("Long Press active!")
                detailedItem = itemArray[indexPath.row]
                print(detailedItem?.itemName)
                performSegue(withIdentifier: "goToDetailsSegue", sender: UITableViewCell.self)
            }
        }
    }
    
    
    //MARK: - Save and Load Functions
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error saving stores \(error)")
        }
        tableView.reloadData()
    }
    
    
    //LoadItems using Search Request Only
        func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
            do {
                itemArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            tableView.reloadData()
        }

    


}
//MARK: - Search bar methods

extension ItemTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        request.predicate = predicate
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
