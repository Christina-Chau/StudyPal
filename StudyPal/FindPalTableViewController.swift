//
//  FindPalTableViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/28/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class FindPalTableViewController: UIViewController{
    
    ///An array to hold all the pals that the user connected with
    private var currentPals: [NSManagedObject] = []
    
    @IBOutlet var tableView: UITableView!
    
    
    /**
     Method to populate the currentPals array to fill up the table 
     */
    func populate(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "partner_username") as? String == usernameFinal{
                    let entryID = data.value(forKey: "entry_id") as? Int
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ClassEntry")
                    request.returnsObjectsAsFaults = false
                    do {
                        let result = try context.fetch(request)
                        for entry in result as! [NSManagedObject] {
                            if entry.value(forKey: "entry_id") as? Int == entryID{
                                currentPals.append(entry)
                            }
                        }

                    } catch {
                        print("Failed")
                    }
                }
            }
            
        } catch {
            print("Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPals.removeAll()
        populate()
        print(currentPals.count)
        self.tableView.reloadData()
    }
}

extension FindPalTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return currentPals.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = currentPals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PalCell", for: indexPath)
        let className = cell.viewWithTag(10) as! UILabel
        let studyType = cell.viewWithTag(11) as! UILabel
        let username = cell.viewWithTag(12) as! UILabel

        className.text = entry.value(forKey: "class_name") as? String
        studyType.text = entry.value(forKey: "study_type") as? String
        username.text = entry.value(forKey: "user_name") as? String
        return cell
    }
}
