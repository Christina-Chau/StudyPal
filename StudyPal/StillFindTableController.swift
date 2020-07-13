//
//  StillFindTableController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/29/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class StillFindTableController: UIViewController {
    
    ///An array to hold all the pals that the user wants to find
    private var findPals: [NSManagedObject] = []

    @IBOutlet var tableView: UITableView!
    
    /**
     Method to populate the currentPals array to fill up the table
     */
    func populate(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "user_name") as? String == usernameFinal) && (data.value(forKey: "full") as? Bool == false){
                    findPals.append(data)
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
        findPals.removeAll()
        populate()
        self.tableView.reloadData()
    }

}

extension StillFindTableController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return findPals.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = findPals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindCell", for: indexPath)
        let className = cell.viewWithTag(10) as! UILabel
       let studyType = cell.viewWithTag(11) as! UILabel
       let username = cell.viewWithTag(12) as! UILabel
        className.text = entry.value(forKey: "class_name") as? String
       studyType.text = entry.value(forKey: "study_type") as? String
       username.text = entry.value(forKey: "user_name") as? String
        return cell
    }
}
