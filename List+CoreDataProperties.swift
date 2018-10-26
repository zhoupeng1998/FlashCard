//
//  List+CoreDataProperties.swift
//  NewFlashCard
//
//  Created by 周澎 on 3/16/16.
//  Copyright © 2016 ZP. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension List {

    @NSManaged var listName: String?
    
    @NSManaged var cards: NSSet?

}
