//
//  AddPalTableViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 7/2/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class AddPalTableViewController: UITableViewController {

   override func viewDidLoad() {
            super.viewDidLoad()
            populateClassPicker()
            classPicker.delegate = self
            classPicker.dataSource = self
            studyPicker.delegate = self
            studyPicker.dataSource = self
            groupPicker.delegate = self
            groupPicker.dataSource = self

    }
        
    // MARK: - Class Picker
    
    /// An array of the classes
    private var classNames: [String] = []
    
    /**
    Method that populates the array classNames that will be used later for the picker
     */
    func populateClassPicker(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Classes")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                classNames.append(data.value(forKey: "class_name") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    
    // MARK: - Other Variables
    
    /// An array if the different stucy options that the users can choose
    private var studyType = ["Homework", "Review Lectures", "Midterm", "Final"]
    
    /// An array of the different group sizes that the users can choose
    private var groupSize = ["Partner", "Group (3)", "Group (5)"]

    // MARK: - Connections
    
    //Labels
    @IBOutlet weak var classLbl: UILabel!
    @IBOutlet weak var studyLbl: UILabel!
    @IBOutlet weak var groupLbl: UILabel!
    
    //Pickers
    @IBOutlet weak var classPicker: UIPickerView!
    @IBOutlet weak var studyPicker: UIPickerView!
    @IBOutlet weak var groupPicker: UIPickerView!
        
}

// MARK: -Pickers
extension AddPalTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == classPicker{
            return classNames.count
        }
        else if pickerView == studyPicker{
            return studyType.count
        }
        else{
            return groupSize.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == classPicker{
            classLbl.text = classNames[row]
        }
        else if pickerView == studyPicker{
            studyLbl.text = studyType[row]
        }
        else{
            groupLbl.text = groupSize[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == classPicker {
            return classNames[row]

        }
        else if pickerView == studyPicker{
            return studyType[row]
        }
        else{
            return groupSize[row]
        }
    }
}
