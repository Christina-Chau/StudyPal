//
//  ClassEntry+CoreDataProperties.swift
//  StudyPal
//
//  Created by Christina Chau on 6/26/20.
//  Copyright © 2020 Christina Chau. All rights reserved.
//
//

import Foundation
import CoreData


extension ClassEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassEntry> {
        return NSFetchRequest<ClassEntry>(entityName: "ClassEntry")
    }

    @NSManaged public var class_name: String?
    @NSManaged public var user_name: String?
    @NSManaged public var study_type: String?

}
