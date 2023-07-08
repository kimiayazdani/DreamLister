//
//  TypesVC.swift
//  DreamLister
//
//  Created by Kimia Yazdani on 7/8/23.
//

import UIKit
import CoreData

class TypesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, TypeCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Store>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
    }
    
    
    // Table Handling
    
    func configureCell(cell: TypeCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(itemType: item)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as! TypeCell
        self.configureCell(cell: cell, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            print(sections.count)
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            print(sectionInfo.numberOfObjects)
            return sectionInfo.numberOfObjects
            
        }
        return 0
    }
    
    // Data Handling
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! TypeCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
            }
            break
            
        }
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()

//        let titleSort = NSSortDescriptor(key:"name", ascending:true)
        

        fetchRequest.sortDescriptors = []
        
        self.controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller.delegate = self
        
        do {
            try self.controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error.localizedDescription.debugDescription)")
        }
        
        tableView.reloadData()
    }
    
    // Handle Deletion
    
    func typeCellDidRequestDeletion(_ cell: TypeCell) {
        let itemType = cell.itemType
            
            let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this item type?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                // Perform the deletion
             
                context.delete(itemType!)
                ad.saveContext()
                
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
        }
    
}
