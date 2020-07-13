//
//  Accounts+CoreDataProperties.swift
//  StudyPal
//
//  Created by Christina Chau on 6/26/20.
//  Copyright © 2020 Christina Chau. All rights reserved.
//
//

import Foundation
import CoreData


extension Accounts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accounts> {
        return NSFetchRequest<Accounts>(entityName: "Accounts")
    }

    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var user_name: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?

}
