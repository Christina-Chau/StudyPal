//
//  CreateAccountViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/24/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class CreateAccountViewController: UIViewController{
    
    // CONNECTIONS//
    @IBOutlet weak var firstnameLbl: UITextField!
    @IBOutlet weak var lastnameLbl: UITextField!
    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var repassLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    
    
    @IBAction func createAccount(_ sender: UIButton) {
        firstName = firstnameLbl.text
        lastName = lastnameLbl.text
        userName = usernameLbl.text
        password = passwordLbl.text
        retypePass = repassLbl.text
        email = emailLbl.text
        
        checkCreateAccount()
    }
    
    /// The first name of the user
    private var firstName: String?
    
    /// The last name of the user
    private var lastName: String?
    
    /// The username of the user
    private var userName: String?
    
    /// The user's password
    private var password: String?
    
    /// The password that the user reenters
    private var retypePass: String?
    
    /// The user's email
    private var email: String?
    
    /**
     Method that creates a new account for the user
     
     If the email already belongs to another account, then the user is given an alert
     If the username already exists, the user is prompted to enter another username
     If the passwords do not match, the user is given an alert
     Else, the account is created
     */
    func checkCreateAccount(){
        //check if the fields are empty
        if (firstnameLbl.text!.count == 0) || (lastnameLbl.text!.count == 0) || (usernameLbl.text!.count == 0) || (passwordLbl.text!.count == 0) || (repassLbl.text!.count == 0) || (emailLbl.text!.count == 0){
            let alert = UIAlertController(title: "ALERT", message: "Fields cannot be empty", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
        }
        //check if email is already there
        else if emailExists(email: email!){
            let alert = UIAlertController(title: "ALERT", message: "This account already exists. Please sign in instead", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
        }
        
        //check if username exists
        if userNameExists(username: userName!){
            let alert = UIAlertController(title: "ALERT", message: "The username \(userName!) already exists. Please try another one", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
        }
        
        //check if password matches
        if password != retypePass{
            let alert = UIAlertController(title: "ALERT", message: "The passwords do not match. Please try again.", preferredStyle: .alert)
        
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
        //else create an account
        else{
            createAccount()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabIdentifier") as! TabViewController
             navigationController?.pushViewController(vc,
             animated: true)
            vc.username = self.userName
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    /**
     Method that sets up a NSManagedObject to be used in later functions
     
     - Returns: A NSManagedObjectContext object
     */
    func getManagedObjectContext() -> NSManagedObjectContext{

        let delegate = UIApplication.shared.delegate as? AppDelegate

        return delegate!.persistentContainer.viewContext
    }
    
    /**
    Method that checks to see if the email that the user has entered already has an account associated with it
     
     - Parameter email: The email to check
     
     - Returns: True if the email exists and false otherwise
     */
    func emailExists(email:String) -> Bool{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        let predicate = NSPredicate(format: "email == %@", email)
        request.predicate = predicate
        request.fetchLimit = 1
         let managedContext = getManagedObjectContext()

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
    
    /**
    Method that checks if the username that the user entered already exists
     
     - Parameter username: The username to check
     
     - Returns: True is the username exists and false otherwise
     */
    func userNameExists(username: String) -> Bool{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        let predicate = NSPredicate(format: "user_name == %@", username)
        request.predicate = predicate
        request.fetchLimit = 1
        let managedContext = getManagedObjectContext()

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
    
    /**
        Method that creates a new account for user and inputs it into the Accounts table in the database
     */
    func createAccount(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Accounts", in: managedContext)!

        let account = NSManagedObject(entity: entity, insertInto: managedContext)

        account.setValue(email, forKeyPath: "email")
        account.setValue(firstName, forKeyPath: "first_name")
        account.setValue(lastName, forKeyPath: "last_name")
        account.setValue(password, forKeyPath: "password")
        account.setValue(userName, forKeyPath: "user_name")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
