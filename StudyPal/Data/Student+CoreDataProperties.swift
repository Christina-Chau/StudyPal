//
//  Student+CoreDataProperties.swift
//  StudyPal
//
//  Created by Christina Chau on 6/26/20.
//  Copyright © 2020 Christina Chau. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var user_name: String?
    @NSManaged public var class_name: String?
    @NSManaged public var study_type: String?
    @NSManaged public var groupsize: String?
    @NSManaged public var connection_num: Int16

}
