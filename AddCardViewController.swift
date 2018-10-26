//
//  AddCardViewController.swift
//  NewFlashCard
//
//  Created by 周澎 on 3/22/16.
//  Copyright © 2016 ZP. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddCardViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var TermTextField: UITextField!
    @IBOutlet weak var DefinitionTextField: UITextField!
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var category: List?
    var lists = [List]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        let sortDescriptor = NSSortDescriptor(key: "listName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            // if let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Player] {
            // categories = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Category]
            lists = try managedObjectContext.fetch(fetchRequest) as? [List] ?? [List]()
        } catch _ {
            
        }
    }
    
    
    @IBAction func SaveButton(_ sender: AnyObject) {
        Save()
    }
    
    
    @IBAction func CancelButton(_ sender: AnyObject) {
        dismiss(animated: true) {}
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.TermTextField.resignFirstResponder()
        self.DefinitionTextField.resignFirstResponder()
        Save()
        return true
    }
    
    
    func Save () {
        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Card", into: managedObjectContext) as! Card
        
        let term = TermTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        let definition = DefinitionTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if term.characters.count != 0 && definition.characters.count != 0{
            newCard.cardTerm = TermTextField.text!
            newCard.cardDefinition = DefinitionTextField.text
            newCard.lists = self.category
            
            do {
                try managedObjectContext.save()
            } catch _ {
            }
            dismiss(animated: true) {}
        }
    }
}

/*

extension AddCardViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lists.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lists[row].listName
    }
}
 
 */

