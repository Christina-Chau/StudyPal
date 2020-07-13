//
//  PalsViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/30/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class PalsViewController: UIViewController, NewPalDelegate {
    
    
    @IBOutlet var palTable: UITableView!
    
    /// The class name of the entry
    private var className:String?
    
    /// The study type of the entry
    private var studyType: String?
    
    /// The group size that the user wants
    private var groupSize: String?
    
    //MARK: -Get information
    
    /**
    Method that takes the information from the NewPalViewController and saves it into variables that this controller can use
     
     - Parameters:
            - name: The class name
            - study: The type of the study session
            - group: The size of the group
     */
    func passInfo(name: String, study: String, group: String) {
        self.className = name
        self.studyType = study
        self.groupSize = group
        saveInStudent()
        saveInClass()
        self.palTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "palInfoSegue"){
            let controller = segue.destination as! NewPalViewController
            controller.delegate = self
        }
    }
    
    //MARK: -Add to database
    
    /**
     Method that adds the entry into the Student database table as well as appends it to the entry array
     */
    func saveInStudent(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Student", in: managedContext)!
        
        let assign = NSManagedObject(entity: entity, insertInto: managedContext)
        
        assign.setValue(className, forKeyPath: "class_name")
        assign.setValue(groupSize, forKeyPath: "groupsize")
        assign.setValue(studyType, forKeyPath: "study_type")
        assign.setValue(usernameFinal, forKeyPath: "user_name")
        assign.setValue(0, forKeyPath: "connection_num")
        assign.setValue(false, forKeyPath: "full")
        do {
            try managedContext.save()
            entry.append(assign)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /**
     Method that adds the entry in the ClassEntry table in the database 
     */
    func saveInClass(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ClassEntry", in: managedContext)!
        
        let assign = NSManagedObject(entity: entity, insertInto: managedContext)
        
        assign.setValue(className, forKeyPath: "class_name")
        assign.setValue(studyType, forKeyPath: "study_type")
        assign.setValue(usernameFinal, forKeyPath: "user_name")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ClassEntry")
        do{
            let count = try managedContext.count(for: fetchRequest)
            assign.setValue((count + 1), forKeyPath: "entry_id")
        }
        catch let error as NSError{
            print("Could not count \(error), \(error.userInfo)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.palTable.reloadData()
    }
}

extension PalsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return entry.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        
    }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pal = entry[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
    
//        let image = cell.viewWithTag(10) as! UIImageView
        let className = cell.viewWithTag(11) as! UILabel
        let studyType = cell.viewWithTag(12) as! UILabel
        let groupSize = cell.viewWithTag(13) as! UILabel
    
        className.text = pal.value(forKeyPath: "class_name") as? String
        studyType.text = pal.value(forKeyPath:"study_type") as? String
    
        let group = pal.value(forKeyPath: "groupsize")as? String
        groupSize.text = group
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pal = entry[indexPath.row]
            entry.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")

           let name = pal.value(forKeyPath: "class_name") as? String
           let group = pal.value(forKeyPath: "groupsize") as? String
           let study = pal.value(forKeyPath: "study_type") as? String
           let user = pal.value(forKeyPath: "user_name") as? String
           request.predicate = NSPredicate(format:"%K == %@ AND %K == %@ AND %K == %@ AND %K == %@", argumentArray:["class_name", name!, "groupsize", group!,"study_type",study!,"user_name",user!])

            let result = try? context.fetch(request)
            let resultData = result as! [NSManagedObject]

            for object in resultData {
                context.delete(object)
            }
            removeInClassEntry(obj: pal)
            do {
                try context.save()
                self.palTable.reloadData()
            } catch {
                // add general error handle here
            }
        }
    }
    
    /**
    Method to remove the entry from the classEntry table in the database
     - Parameter obj: The entry to remove from ClassEntry table
     */
    func removeInClassEntry(obj: NSManagedObject){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ClassEntry")
            request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "class_name") as? String == obj.value(forKey:"class_name") as? String) && (data.value(forKey: "study_type") as? String == obj.value(forKey:"study_type") as? String) && (data.value(forKey: "uesr_name") as? String == obj.value(forKey:"user_name") as? String){
                    removeInEntry(id: (data.value(forKey: "entry_id") as? Int)!)
                        context.delete(data)
                }
                do {
                    try context.save()
                } catch {
                    // add general error handle here
                }
            }
        }catch {
            print("Failed")
        }
    }
    
    /**
    Method to remove the entry from the Entry table in the database
     - Parameter id: The id of the entry to remove in the Entry table
     */
    func removeInEntry(id: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
            request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "entry_id") as? Int == id{
                        context.delete(data)
                }
                do {
                    try context.save()
                } catch {
                    // add general error handle here
                }
            }
        }catch {
            print("Failed")
        }
    }
}
    

