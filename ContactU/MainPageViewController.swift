//
//  MainPageViewController.swift
//  ContactU
//
//  Created by Alexandre Pierroz on 01.05.15.
//  Copyright (c) 2015 Training. All rights reserved.
//

import UIKit
import CoreData

class MainPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet var firstNameLabel: UILabel! = UILabel()
    
    @IBOutlet var lastNameLabel: UILabel! = UILabel()
    
    @IBOutlet var anneeLabel: UILabel! = UILabel()
    
    @IBOutlet var kmLabel: UILabel! = UILabel()
    
    @IBOutlet var contactImageView: UIImageView! = UIImageView()
    
    @IBOutlet var collectionView: UICollectionView!
    
    var toDoItems:NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var logoImage:UIImage = UIImage(named: "smartRIDER")!
        self.navigationItem.titleView = UIImageView(image: logoImage)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        loadData()
        
        if toDoItems.count == 0 {
            let nv = self.storyboard!.instantiateViewControllerWithIdentifier("AddMoto") as! AddContactTableViewController
            
            self.navigationController!.pushViewController(nv, animated: true)
        }
        
        afficheMoto(0)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        loadData()
        return toDoItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: cvwCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! cvwCell
        
        let infoDict:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as! NSDictionary
        
        let firstName:NSString = infoDict.objectForKey("firstName") as! NSString
        
        
        cell.lblCell.text = firstName as String
        cell.imgCell.image = infoDict.objectForKey("profileImage") as? UIImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        afficheMoto(indexPath.row)
        
    }
    
    
    
    func loadData(){
        toDoItems.removeAllObjects()
        
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let results:NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(ToDoItem), withPredicate: nil, managedObjectContext: moc)
        
        if results.count > 0 {
            
            for toDo in results{
                let singleToDoItem:ToDoItem = toDo as! ToDoItem
                
                let identifier = singleToDoItem.identifier
                
                let contact:Contact = singleToDoItem.contact
                
                let firstName = contact.firstName
                let lastName = contact.lastName
                let email = contact.email
                let phone = contact.phone
                
                let dueDate = singleToDoItem.dueDate
                let title = singleToDoItem.note
                
                let profileImage:UIImage = UIImage(data: contact.contactImage)!
                
                let dict:NSDictionary = ["identifier":identifier,"firstName":firstName, "lastName":lastName, "email":email, "phone":phone, "dueDate":dueDate, "title":title, "profileImage":profileImage]
                
                toDoItems.addObject(dict)
                
                
            }
            
            let dateDescriptor:NSSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
            var sortedArray:NSArray = toDoItems.sortedArrayUsingDescriptors([dateDescriptor])
            
            toDoItems = NSMutableArray(array: sortedArray)
            
            
        }
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    
    
    func afficheMoto(index: Int) {
        
        let infoDict:NSDictionary = toDoItems.objectAtIndex(index) as! NSDictionary
        
        let firstName:NSString = infoDict.objectForKey("firstName") as! NSString
        let lastName:NSString = infoDict.objectForKey("lastName") as! NSString
        let email:NSString = infoDict.objectForKey("email") as! NSString
        
        let phone:NSString = infoDict.objectForKey("phone") as! NSString
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        
        let dateString:NSString = dateFormatter.stringFromDate(infoDict.objectForKey("dueDate") as! NSDate)
        
        contactImageView.image = infoDict.objectForKey("profileImage") as? UIImage
        
        firstNameLabel.text = firstName as String
        lastNameLabel.text = lastName as String
        anneeLabel.text = email as String
        kmLabel.text = "KM: " + toString(phone)
      
    }
    
    
    func delete (cellForRowAtIndexPath indexPath: NSIndexPath) {
        
            if (toDoItems.count > 0){
                let infoDict:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as! NSDictionary
                
                let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
                
                let identifier:NSString = infoDict.objectForKey("identifier") as! NSString
                
                let predicate:NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")
                
                let results:NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(ToDoItem), withPredicate: predicate, managedObjectContext: moc)
                
                let toDoItemToDelete:ToDoItem = results.lastObject as! ToDoItem
                
                toDoItemToDelete.managedObjectContext!.deleteObject(toDoItemToDelete)
                
                SwiftCoreDataHelper.saveManagedObjectContext(moc)
                
                loadData()
                
                
                
            }
            
        }
    
    
    
    
    
    
    
    
}
