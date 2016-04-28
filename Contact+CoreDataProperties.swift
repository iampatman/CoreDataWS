//
//  Contact+CoreDataProperties.swift
//  ContactCoreDataEx
//
//  Created by Nguyen Bui An Trung on 28/4/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var phone: String?

}
