//
//  Data+CoreDataProperties.swift
//  HH Schedule
//
//  Created by Jack Crawford on 8/23/16.
//  Copyright © 2016 Jack Crawford. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Data {

    @NSManaged var count: NSNumber?
    @NSManaged var image: NSData?

}
