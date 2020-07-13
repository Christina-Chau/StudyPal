//
//  SignInViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/24/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {

    //CONNECTIONS//
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    
    @IBAction func signIn(_ sender: UIButton) {
        if emailLbl.text!.count > 0 && passwordLbl.text!.count > 0{
            email = emailLbl.text
            password = passwordLbl.text
            checkSignIn()
        }
        else{
            let alert = UIAlertController(title: "ALERT", message: "Fields cannot be empty", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
        }
    }
    
    /// The user's email
    private var email: String?
    
    /// The user's password
    private var password: String?
    
    /// The user's username
    private var username: String?
    
    /**
    Method to see if the user can sign in successfully
     */
    func checkSignIn(){
        if checkEmail(email: email!){
            if checkPassword(email: email!, password: password!){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabIdentifier") as! TabViewController
                 navigationController?.pushViewController(vc,
                 animated: true)
                vc.username = self.username
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "ALERT", message: "Your password is incorrect. Please try again.", preferredStyle: .alert)
                
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    
                    alert.addAction(okAction)
                    
                    present(alert, animated: true)
            }
        }
        else{
            let alert = UIAlertController(title: "ALERT", message: "Your email is incorrect. Please try again.", preferredStyle: .alert)
            
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                
                alert.addAction(okAction)
                
                present(alert, animated: true)
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
    Method that checks to see if the email that the user entered matches any account
     
     - Parameter email: The email to check
     
     - Returns: True if there is a match and false otherwise
     */
    func checkEmail(email:String) -> Bool{
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
    Method that checks to see if the password the user enters matches the password for the associated email
         
    - Parameters:
            - email: The email of the account
            - password: The password to check
     
    - Returns: True if the password matches and false otherwise
     
     */
    func checkPassword(email: String, password: String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
            let predicate = NSPredicate(format: "email = %@", argumentArray: [email])

            fetch.predicate = predicate

            do {

              let result = try context.fetch(fetch)
              for data in result as! [NSManagedObject] {
                if(data.value(forKey: "password") as! String == password){
                    username = data.value(forKey: "user_name") as! String?
                    return true
                }
              }
            } catch {
              print("Failed")
            }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
