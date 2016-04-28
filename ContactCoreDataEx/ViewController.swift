//
//  ViewController.swift
//  ContactCoreDataEx
//
//  Created by Nguyen Bui An Trung on 28/4/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var contactsTable: UITableView!
    
    var contacts = [String]()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var contactObject: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        contactsTable.delegate = self
        contactsTable.dataSource = self
        name.delegate = self
        phone.delegate = self
        address.delegate = self
        loadAllContacts()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func hideKeyboard(){
        name.resignFirstResponder()
        phone.resignFirstResponder()
        address.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func loadAllContacts(){
        let entityDescription = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: managedObjectContext)
        let request = NSFetchRequest()
        request.entity = entityDescription
        contacts = []
        do {
            let results = try managedObjectContext.executeFetchRequest(request)
            if results.count > 0 {
                for match in results as! [NSManagedObject] {
                    contacts.append(match.valueForKey("name") as! String)
                }
            }
            
        } catch let error as NSError {

            status.text = "Error: " + error.localizedFailureReason!
            print("Failed: \(error.localizedDescription)" )
            
        }
        contactsTable.reloadData()

    }

    @IBAction func createContact(sender: AnyObject) {
        hideKeyboard()
        let entityDescription = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: managedObjectContext)
        let contact = Contact(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        contact.name = name.text
        contact.address = address.text
        contact.phone = phone.text
        
        do {
            try managedObjectContext.save()
            status.text = "Contact created"
            name.text = ""
            address.text = ""
            phone.text = ""
            loadAllContacts()
        } catch let error as NSError {
            status.text = "Error: " + error.localizedFailureReason!
            print("Failed: \(error.localizedDescription)" )
        }
    }
    
    @IBAction func deleteContact(sender: AnyObject) {

        if (contactObject == nil) {
            status.text = "Contact not found"
            return;
        }
        hideKeyboard()

        managedObjectContext.deleteObject(contactObject)
        
        do {
            try managedObjectContext.save()
            status.text = "Contact deleted"
            loadAllContacts()
        } catch let error as NSError {
            status.text = "Error: " + error.localizedFailureReason!
            print("Failed: \(error.localizedDescription)" )
        }

    }
    @IBAction func findContact(sender: AnyObject) {
        hideKeyboard()

        let entityDescription = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: managedObjectContext)
        let request = NSFetchRequest()
        request.entity = entityDescription
        let pred = NSPredicate(format: "name = %@", name.text!)
        request.predicate = pred
        do {
            let results = try managedObjectContext.executeFetchRequest(request)
            if results.count > 0 {
                let match = results[0] as! NSManagedObject
                name.text = (match.valueForKey("name") as! String)
                address.text = (match.valueForKey("address") as! String)
                phone.text = (match.valueForKey("phone") as! String)
                status.text = "Matches found: \(results.count)"
                
                contactObject = match as! Contact
            } else {
                name.text = ""
                address.text = ""
                phone.text = ""
                status.text = "Record not found"
            }
        } catch let error as NSError {
            name.text = ""
            address.text = ""
            phone.text = ""
            status.text = "Error: " + error.localizedFailureReason!
            print("Failed: \(error.localizedDescription)" )

        }
    }
    @IBAction
    func updateContact(sender: AnyObject) {
        hideKeyboard()

        if (contactObject == nil) {
            status.text = "Contact not found"
            return;
        }
        contactObject.address = address.text
        contactObject.phone = phone.text
        do {
            try managedObjectContext.save()
            status.text = "Contact updated"
            address.text = ""
            phone.text = ""
        } catch let error as NSError {
            status.text = "Error: " + error.localizedFailureReason!
            print("Failed: \(error.localizedDescription)" )
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //implement table view delegate and datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = contacts[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

}

