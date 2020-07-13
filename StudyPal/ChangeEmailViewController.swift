//
//  ChangeEmailViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 7/5/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class ChangeEmailViewController: UIViewController {

    /// The user's email adress
    var email: String?
    
    @IBOutlet weak var changeEmailLbl: UITextField!
    @IBOutlet weak var saveOutlet: UIButton!
    
    @IBAction func emailChanged(_ sender: UITextField) {
        saveOutlet.isEnabled = true
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "user_name") as? String == usernameFinal{
                    if emailExists(email: changeEmailLbl.text!){
                        let alert = UIAlertController(title: "ALERT", message: "The email  already exists. Please try another one", preferredStyle: .alert)
                                   
                                       let okAction = UIAlertAction(title: "OK", style: .cancel)
                                       
                                       alert.addAction(okAction)
                                       
                                       present(alert, animated: true)
                    }
                    else{
                         data.setValue(changeEmailLbl.text, forKey: "email")
                    }
                }
            }
        } catch {
            print("Failed")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settingsIdentifier") as! SettingsViewController
         navigationController?.pushViewController(vc,
         animated: true)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settingsIdentifier") as! SettingsViewController
         navigationController?.pushViewController(vc,
         animated: true)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    /**
    Method that checks if the username that the user entered already exists
     
     - Parameter email: The username to check
     
     - Returns: True is the username exists and false otherwise
     */
    func emailExists(email: String) -> Bool{
        let delegate = UIApplication.shared.delegate as? AppDelegate

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        let predicate = NSPredicate(format: "email == %@", email)
        request.predicate = predicate
        request.fetchLimit = 1
        let managedContext =   delegate!.persistentContainer.viewContext

        do{
            let count = try managedContext.count(for: request)
            if(count == 0){
                return false
            }
          }
        catch let error as NSError {
             print("Could not fetch \(error), \(error.userInfo)")
          }
        return true
    }
    
    override func viewDidLoad() {
        changeEmailLbl.text = email
        saveOutlet.isEnabled = false
        super.viewDidLoad()
    }

}
