//
//  MainTableViewController.swift
//  NewFlashCard
//
//  Created by 周澎 on 3/17/16.
//  Copyright © 2016 ZP. All rights reserved.
//


import Foundation
import UIKit
import CoreData


class MainTableViewController: UITableViewController {
    
    let managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    var fetchedResultsController: NSFetchedResultsController<AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch _ {
        }
    }
    
    func fetchRequest() -> NSFetchRequest<AnyObject> {
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        let sortDescriptor = NSSortDescriptor(key: "listName", ascending: true)
        
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        return fetchRequest
    }
}

// MARK: UITableView Data Source & Delegate
extension MainTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as UITableViewCell
        let folder = fetchedResultsController?.object(at: indexPath) as? List
        cell.textLabel?.text = folder?.listName
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardListSegue" {
            let destination = segue.destination as! CardViewController
            let indexPath = self.tableView?.indexPath(for: sender as! UITableViewCell)
            destination.category = fetchedResultsController?.object(at: indexPath!) as? List
        }
    }

}

// MARK: IBActions
extension MainTableViewController: UIAlertViewDelegate {
    
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func AddListButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add a List", message: "Enter a name:", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "List Name"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        let save = UIAlertAction(title: "Save", style: .default) { action in
            let newList = NSEntityDescription.insertNewObject(forEntityName: "List", into: self.managedObjectContext!) as! List
            newList.listName = (alert.textFields! as [UITextField])[0].text ?? "unk"
            
            do {
                try self.managedObjectContext?.save()
            } catch _ {
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        present(alert, animated: true) {}
    }
    
}

// MARK: NSFetchedResultsController Delegate
extension MainTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            managedObjectContext?.delete(fetchedResultsController?.object(at: indexPath) as! List)
            do {
                try managedObjectContext?.save()
            } catch _ {
            }
        case .insert:
            break
        case .none:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case NSFetchedResultsChangeType.delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case NSFetchedResultsChangeType.move:
            break
        case NSFetchedResultsChangeType.update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        }
    }
}
