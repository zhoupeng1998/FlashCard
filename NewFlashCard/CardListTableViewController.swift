//
//  CardListTableViewController.swift
//  NewFlashCard
//
//  Created by 周澎 on 3/20/16.
//  Copyright © 2016 ZP. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CardViewController: UITableViewController {
    
    @IBOutlet weak var TitleBar: UINavigationItem!
    
    let managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    var fetchedResultsController: NSFetchedResultsController<AnyObject>?
    var category: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TitleBar.title = category?.listName
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch _ {
        }
    }
    
    func fetchRequest() -> NSFetchRequest<AnyObject> {
        
        let fetchRequest = NSFetchRequest(entityName: "Card")
        let sortDescriptor = NSSortDescriptor(key: "cardTerm", ascending: true)
        
        let predicate = NSPredicate(format: "lists == %@", category ?? List())
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        return fetchRequest
    }
}

// MARK: UITableView Data Source & Delegate
extension CardViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as UITableViewCell
        let card = fetchedResultsController?.object(at: indexPath) as? Card
        
        cell.textLabel?.text = card?.cardTerm
        cell.detailTextLabel?.text = card?.cardDefinition
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FlashCardSegue" {
            let destination = segue.destination as! FlashCardViewController
            let indexPath = self.tableView?.indexPath(for: sender as! UITableViewCell)
            destination.FlashCard = fetchedResultsController?.object(at: indexPath!) as? Card
            destination.category = self.category
            destination.indexPath = indexPath
        }
        if segue.identifier == "AddCardSegue" {
            let destination = segue.destination as! AddCardViewController
            destination.category = self.category
        }
    }
}

// MARK: NSFetchedResultsController Delegate
extension CardViewController: NSFetchedResultsControllerDelegate {
    
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
            managedObjectContext?.delete(fetchedResultsController?.object(at: indexPath) as! Card)
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
