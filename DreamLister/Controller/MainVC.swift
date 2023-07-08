//
//  ViewController.swift
//  DreamLister
//
//  Created by Kimia Yazdani on 6/30/23.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    var wascalled = false
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var finishedFilterSwitch: UISwitch!
    @IBOutlet weak var SegmentedBtns: UISegmentedControl!
    @IBOutlet weak var ItemsTableView: UITableView!
    

    
    var controller: NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemsTableView.dataSource = self
        ItemsTableView.delegate = self
        
        finishedFilterSwitch.isOn = false

        attemptFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if wascalled == false {
            generateTestDate()
            wascalled = true
        }
        attemptFetch()
    }
    
    // Table Handling Functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ItemsTableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemVCDetails", sender: item)
        }
    }
    
    // Data Handling Functions
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        // Sort Types
        let dateSort =  NSSortDescriptor(key:"created", ascending:false)
        let priceSort = NSSortDescriptor(key:"price", ascending:false)
        let titleSort = NSSortDescriptor(key:"title", ascending:true)
        
        if SegmentedBtns.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if SegmentedBtns.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let predicate = NSPredicate(format: "finished == %@", NSNumber(value: finishedFilterSwitch.isOn)) 
        fetchRequest.predicate = predicate

        
        self.controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller.delegate = self
        
        do {
            try self.controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error.localizedDescription.debugDescription)")
        }
        
        ItemsTableView.reloadData()
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ItemsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ItemsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                ItemsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                ItemsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = ItemsTableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                ItemsTableView.deleteRows(at: [indexPath], with: .fade)
                if let newIndexPath = newIndexPath {
                    ItemsTableView.insertRows(at: [newIndexPath], with: .fade)
                }
            }
            break
            
        }
    }
    
    func generateTestDate() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return
            }
        } catch {
            print("Error fetching existing objects: \(error.localizedDescription)")
            return
        }
            
        
        let store9 = Store(context: context)
        store9.name = "Others"
        store9.color = "FFFFFF"
        ad.saveContext()
        
        let store = Store(context: context)
        store.name = "Exercise"
        store.color = "3FFFFF"
        let store10 = Store(context: context)
        store10.name = "Just Have To"
        store10.color = "656763"
        let store2 = Store(context: context)
        store2.name = "Computer Science"
        store2.color = "000000"
        let store3 = Store(context: context)
        store3.name = "Business"
        store3.color = "D3B142"
        let store4 = Store(context: context)
        store4.name = "Nature"
        store4.color = "14B142"
        let store5 = Store(context: context)
        store5.name = "Art"
        store5.color = "AC30B1"
        let store6 = Store(context: context)
        store6.name = "Mission"
        store6.color = "B2FFB1"
        let store7 = Store(context: context)
        store7.name = "Footprint"
        store7.color = "607CB1"
        let store8 = Store(context: context)
        store8.name = "People"
        store8.color = "FF9C42"

        
        let picture = Image(context: context)
        picture.image = UIImage(systemName:"moon.fill")
        
        let item = Item(context: context)
        item.title = "Ipad"
        item.price = 1000
        item.details = "I need it to draw badass digital drawings!"
        item.finished = false
        item.toImage = picture
        item.toStore = store7
        
        
        let item2 = Item(context: context)
        item2.title = "Impossible Steak"
        item2.price = 20
        item2.details = "I can't wait until Impossible Foods discovers how to make steak texture!"
        item2.finished = true
        item2.toImage = picture
        item2.toStore = store3
        
        let item3 = Item(context: context)
        item3.title = "Glasses"
        item3.price = 100
        item3.details = "I hope Parsa doesn't throw this on the ground every single morning so that I don't have to put it back on my DreamList for a while."
        item3.finished = false
        item3.toImage = picture
        item3.toStore = store2
        
        
        ad.saveContext()

    }
    
    // Actions
    @IBAction func finishedFilterChange(_ sender: Any) {
        attemptFetch()
        if finishedFilterSwitch.isOn {
            navigationBar.title = "Finished"
        } else {
            navigationBar.title = "In Progress"
        }
        ItemsTableView.reloadData()
    }
    
    // Utilities
    
    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        ItemsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemVCDetails" {
            if let destination = segue.destination as?
                ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
}

