//
//  Classes+CoreDataProperties.swift
//  StudyPal
//
//  Created by Christina Chau on 6/26/20.
//  Copyright © 2020 Christina Chau. All rights reserved.
//
//

import Foundation
import CoreData


extension Classes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Classes> {
        return NSFetchRequest<Classes>(entityName: "Classes")
    }

    @NSManaged public var class_name: String?
    @NSManaged public var class_decsr: String?

}
