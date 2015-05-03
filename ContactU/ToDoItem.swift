//
//  ToDoItem.swift
//  
//
//  Created by Alexandre Pierroz on 30.04.15.
//
//

import Foundation
import CoreData

@objc(ToDoItem)
class ToDoItem: NSManagedObject {

    @NSManaged var dueDate: NSDate
    @NSManaged var identifier: String
    @NSManaged var note: String
    @NSManaged var contact: Contact

}
