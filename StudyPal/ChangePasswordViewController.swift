//
//  ChangePasswordViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 7/5/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet weak var onePassLbl: UITextField!
    @IBOutlet weak var secondPassLbl: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    @IBAction func onePassLbl(_ sender: UITextField) {
        if secondPassLbl.text!.count > 0{
            button.isEnabled = true
        }
        else{
             button.isEnabled = false
        }
    }
    
    @IBAction func secondPassLbl(_ sender: UITextField) {
        if onePassLbl.text!.count > 0{
            button.isEnabled = true
        }
        else{
            button.isEnabled = false
        }
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        if(onePassLbl.text == secondPassLbl.text){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if data.value(forKey: "user_name") as? String == usernameFinal{
                        data.setValue(onePassLbl.text, forKey: "password")
                    }
                }
            } catch {
                print("Failed")
            }
        }
        else{
            let alert = UIAlertController(title: "ALERT", message: "The passwords do not match. Please try again", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
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
    
    override func viewDidLoad() {
        button.isEnabled = false
        super.viewDidLoad()
    }

}
