//
//  FlashCardViewController.swift
//  NewFlashCard
//
//  Created by 周澎 on 3/23/16.
//  Copyright © 2016 ZP. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlashCardViewController: UIViewController, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var TitleBar: UINavigationItem!
    
    
    let managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    var fetchedResultsController: NSFetchedResultsController<AnyObject>?
    
    var count = 0
    var FlashCard: Card?
    
    var category: List?
    var indexPath: IndexPath?
    var cardList = [Card]()
    var index: Int = 0
    
    
    
    
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
        
        do{
            self.cardList = try managedObjectContext?.fetch(fetchRequest) as! [Card]
            self.index = ((self.indexPath as NSIndexPath?)?.row)!
            self.FlashCard = self.cardList[index]
            self.TextLabel.text = self.FlashCard?.cardTerm
        } catch _ {
            
        }
        
        return fetchRequest
    }
    

    @IBAction func Scroll(_ sender: UISwipeGestureRecognizer) {
        let scrollDrection = sender.direction
        switch scrollDrection {
        case UISwipeGestureRecognizerDirection.up:
            if self.index < self.cardList.count - 1{
            UIView.animate(withDuration: 0.5, animations: {
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.curlUp, for: self.ContainerView, cache: true)
                    self.index += 1
                    self.FlashCard = self.cardList[self.index]
                    self.TextLabel.text = self.FlashCard?.cardTerm
                    self.count = 0
            })
            }
            break
        case UISwipeGestureRecognizerDirection.down:
            if self.index > 0{
            UIView.animate(withDuration: 0.5, animations: {
                UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.curlDown, for: self.ContainerView, cache: true)
                    self.index -= 1
                    self.FlashCard = self.cardList[self.index]
                    self.TextLabel.text = self.FlashCard?.cardTerm
                    self.count = 0
            })
            }
            break
        case UISwipeGestureRecognizerDirection.left:
            UIView.transition(with: self.ContainerView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                if self.count%2 == 0 {
                    self.TextLabel.text = self.FlashCard!.cardDefinition
                } else {
                    self.TextLabel.text = self.FlashCard!.cardTerm
                }
                }, completion: nil)
            self.count += 1
            break
        case UISwipeGestureRecognizerDirection.right:
            UIView.transition(with: self.ContainerView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                if self.count%2 == 0 {
                    self.TextLabel.text = self.FlashCard!.cardDefinition
                } else {
                    self.TextLabel.text = self.FlashCard!.cardTerm
                }
                }, completion: nil)
            self.count += 1
            break
        default:
            print("You know what i mean.")
            break
        }

    }
    
    
    func animationWithView(_ view:UIView,withAnimationTransition transition:UIViewAnimationTransition){
        
        UIView.animate(withDuration: 0.5, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.setAnimationTransition(transition, for: view, cache: true)
            self.count += 1
        })
    }
    
    
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var TextLabel: UILabel!
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

