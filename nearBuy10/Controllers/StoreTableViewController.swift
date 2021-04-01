//
//  StoreTableViewController.swift
//  nearBuy10
//
//  Created by Jim on 3/23/21.
//

import UIKit
import CoreData

class StoreTableViewController: UITableViewController {

    var storeArray = [Store]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStores()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath)

        cell.textLabel?.text = storeArray[indexPath.row].storeName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToShopping", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "goToShopping" else {return}
        let destinationVC = segue.destination as! ShoppingTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedStore = storeArray[indexPath.row]
            //destinationVC.shoppingLabel = storeArray[indexPath.row]
        }
    }

    @IBAction func addStoreButtonPressed(_ sender: UIBarButtonItem) {
        
        var storeTextField = UITextField()
        let alert = UIAlertController(title: "Add New Store", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newStore = Store(context: self.context)
            newStore.storeName = storeTextField.text!
            self.storeArray.append(newStore)
            self.saveStores()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { (field) in
            storeTextField = field
            storeTextField.placeholder = "Add New Store"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindToStoreView(sender: UIStoryboardSegue) {
        print("Buy button pressed - unwind to Stores")
    }
    
    
    //MARK: - Save and Load functions
    func saveStores() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadStores() {
        
        let request : NSFetchRequest<Store> = Store.fetchRequest()
        
        do{
            storeArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
       
        tableView.reloadData()
        
    }
    
    
    


}
