//
//  AccountTableViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 7/5/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class AccountTableViewController: UITableViewController {
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    /**
     Method to change the labels on the screen
     */
    func createView(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        let predicate = NSPredicate(format: "user_name = %@", argumentArray: [usernameFinal!])

        fetch.predicate = predicate

        do {

          let result = try context.fetch(fetch)
          for data in result as! [NSManagedObject]{
            emailLbl.text = data.value(forKey: "email") as? String
            usernameLbl.text = usernameFinal
            }
        }
        catch {
          print("Failed")
        }
    }
    
    // MARK: -Table functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "emailIdentifier") as! ChangeEmailViewController
             navigationController?.pushViewController(vc,
             animated: true)
            vc.email = emailLbl.text
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "usernameIdentifier") as! ChangeUsernameViewController
             navigationController?.pushViewController(vc,
             animated: true)
            vc.username = usernameLbl.text
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "passwordIdentifier") as! ChangePasswordViewController
             navigationController?.pushViewController(vc,
             animated: true)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createView()
    }

}
