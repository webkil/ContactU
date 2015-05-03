//
//  Contact.swift
//  
//
//  Created by Alexandre Pierroz on 30.04.15.
//
//

import Foundation
import CoreData

@objc(Contact)
class Contact: NSManagedObject {

    @NSManaged var email: String
    @NSManaged var identifier: String
    @NSManaged var phone: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var contactImage: NSData
    @NSManaged var toDoItem: NSSet

}
