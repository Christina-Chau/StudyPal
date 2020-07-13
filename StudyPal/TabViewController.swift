//
//  TabViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/26/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

var usernameFinal:String?
var entry: [NSManagedObject] = []

class TabViewController: UITabBarController {
    
    /// The user's username
    var username: String?
    
    override func viewDidLoad() {
        usernameFinal = username
        super.viewDidLoad()
        populateEntries()
        
    }
    
    /**
     Method to populate the entry array with NSManagedObjects that are for the current user
     */
    func populateEntries(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let predicate = NSPredicate(format: "user_name = %@", argumentArray: [usernameFinal!])

        fetch.predicate = predicate

        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject]{
                entry.append(data)
            }
        }
        catch {
          print("Failed")
        }
    }
}


