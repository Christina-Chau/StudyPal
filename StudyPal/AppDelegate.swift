//
//  AppDelegate.swift
//  StudyPal
//
//  Created by Christina Chau on 6/24/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {

                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
        }
        else
        {
            print("First launch")
            readClassFile()
            //readAccountFile()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        return true
    }
    
    // MARK: -Set Up Accounts on First Launch
    
    /**
     Method to read the class.json file
     */
    func readClassFile(){
        let url = Bundle.main.url(forResource: "class", withExtension: "json")
        let data = NSData(contentsOf: url!)
        func readJSONObject(object: [String: AnyObject]) {
            guard let classes = object["classes"] as? [[String: AnyObject]] else { return }
             
            for c in classes {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                  
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Classes", in: managedContext)!
                  
                let newClass = NSManagedObject(entity: entity, insertInto: managedContext)
                  
                let name = c["className"] as? String
                let desc = c["classDesc"] as? String
                newClass.setValue(name, forKeyPath: "class_name")
                newClass.setValue(desc, forKeyPath: "class_decsr")
                  
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONObject(object: dictionary)
            }
        } catch {
            // Handle Error
        }
    }
    
    /**
     Method to read the accounts.json file into the database
     */
    func readAccountFile(){
        let url = Bundle.main.url(forResource: "accounts", withExtension: "json")
        let data = NSData(contentsOf: url!)
        func readJSONObject(object: [String: AnyObject]) {
            guard let account = object["account"] as? [[String: AnyObject]] else { return }
             
            for a in account {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                  
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Accounts", in: managedContext)!
                  
                let newAccount = NSManagedObject(entity: entity, insertInto: managedContext)
                  
                let email = a["email"] as? String
                let firstName = a["first_name"] as? String
                let lastName = a["last_name"] as? String
                let password = a["password"] as? String
                let userName = a["user_name"] as? String
                newAccount.setValue(email, forKeyPath: "email")
                newAccount.setValue(firstName, forKeyPath: "first_name")
                newAccount.setValue(lastName, forKeyPath: "last_name")
                newAccount.setValue(password, forKeyPath: "password")
                newAccount.setValue(userName, forKeyPath: "user_name")
                print("saved")
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONObject(object: dictionary)
            }
        } catch {
            // Handle Error
        }
    }

    // MARK: -UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

