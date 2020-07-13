//
//  ClassPalsViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 7/3/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class ClassPalsViewController: UIViewController{

    /// The class name that specifies which entries to display
    var className: String?
    
    /// An array of NSManagedObjects that holds all the entries for the specific class
    private var classPals: [NSManagedObject] = []
    
    @IBOutlet weak var classLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet var classPalTable: UITableView!
    
    /**
    Method that populates the classPals array in order to display in the table
     */
    func populate(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "class_name") as? String == className) && (data.value(forKey: "user_name") as? String != usernameFinal){
                    classPals.append(data)
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    override func viewDidLoad() {
        classLbl.text = className
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool){
        classPals.removeAll()
        populate()
        self.classPalTable.reloadData()
        numberLbl.text = "\(classPals.count) PALS"
    }

}

extension ClassPalsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classPals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pal = classPals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let studyType = cell.viewWithTag(10) as! UILabel
        let groupSize = cell.viewWithTag(11) as! UILabel
        let userName = cell.viewWithTag(12) as! UILabel
        let connect = cell.viewWithTag(13) as! UIButton
        
        studyType.text = pal.value(forKeyPath: "study_type") as? String
        groupSize.text = pal.value(forKeyPath: "groupsize") as? String
        userName.text = pal.value(forKeyPath: "user_name") as? String
        connect.tag = indexPath.row
        connect.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        return cell
    }
    
    @objc func didButtonClick(_ sender: UIButton){
        let entryTag = sender.tag
        if (classPals[entryTag].value(forKey: "full") as? Bool)!{
            let alert = UIAlertController(title: "ALERT", message: "Pal has full connections. Please find another pal", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
        }
        else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ClassEntry")
            let className = classPals[entryTag].value(forKey: "class_name") as? String
            let studyType = classPals[entryTag].value(forKey: "study_type") as? String
            let userName = classPals[entryTag].value(forKey: "user_name") as? String
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if (data.value(forKey: "class_name") as? String == className) && (data.value(forKey: "study_type") as? String == studyType) && (data.value(forKey: "user_name") as? String == userName){
                        let courseID = data.value(forKey: "entry_id") as? Int
                        addToEntry(id: courseID!)
                        
                    }
                }
            } catch {
                print("Failed")
            }
            updateConnections(tag:entryTag)
            
            let alert = UIAlertController(title: "ALERT", message: "You have connected with this person.", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
        }
    }
    
    /**
     Method to update the number of connections for the sepcific entry
     
     - Parameter tag: The position of the entry in the array
     */
    func updateConnections(tag:Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let className = classPals[tag].value(forKey: "class_name") as? String
        let groupsize = classPals[tag].value(forKey: "groupsize") as? String
        let studyType = classPals[tag].value(forKey: "study_type") as? String
        let userName = classPals[tag].value(forKey: "user_name") as? String
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "class_name") as? String == className) && (data.value(forKey: "groupsize") as? String == groupsize) && (data.value(forKey: "study_type") as? String == studyType) && (data.value(forKey: "user_name") as? String == userName){
                    var amt = data.value(forKey: "connection_num") as? Int
                    amt! += 1
                    data.setValue(amt!, forKey: "connection_num")
                    
                    if (data.value(forKey: "groupsize") as? String == "Partner") && (amt == 2){
                        data.setValue(true, forKey: "full")
                    }
                    else if (data.value(forKey: "groupsize") as? String == "Group (3)") && (amt == 3){
                        data.setValue(true, forKey: "full")
                    }
                    else{
                        data.setValue(true, forKey: "full")
                    }
                }
            }
            
        } catch {
            print("Failed")
        }
    }
    
    /**
     Method to add the connection into the Entry table in the database
     
     - Parameter id: The id of the entry in the ClassEntry table to match up with in the current table
     */
    func addToEntry(id: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)!
        
        let assign = NSManagedObject(entity: entity, insertInto: managedContext)
        
        assign.setValue(usernameFinal, forKeyPath: "partner_username")
        assign.setValue(id, forKeyPath: "entry_id")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

