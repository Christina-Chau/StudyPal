//
//  ClassesViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/26/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit
import CoreData

class ClassesViewController: UIViewController {
    
    @IBOutlet var classTable: UITableView!
    
    /// An array of NSManagedObjects that are the classes
    var classes: [NSManagedObject] = []
    
    /// An array that holds the users serches
    var filtered: [NSManagedObject] = []
    
    /// Variable that checks if the search bar is empty
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Variable that lets the program knows if the user is currently using the search bar
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    /// A search controller for user to search classes
    let searchController = UISearchController(searchResultsController: nil)
    
    func filterContentForSearchText(_ searchText: String, category: Category? = nil) {
      filtered = classes.filter { (className: NSManagedObject) -> Bool in
            let name = className.value(forKeyPath:"class_name")as? String
        return name!.lowercased().contains(searchText.lowercased())
      }
      
      classTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classTable.dataSource = self
        classTable.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Classes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.classTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
      
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Classes")
      
        do {
            classes = try managedContext.fetch(fetchRequest)
            self.classTable.reloadData()
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

//MARK: - Extension for table
extension ClassesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filtered.count
        }
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let className: NSManagedObject?
        if isFiltering {
            className = filtered[indexPath.row]
        }
        else {
            className = classes[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell",for: indexPath)
        let classname = cell.viewWithTag(10) as! UILabel
        let classdesc = cell.viewWithTag(11) as! UILabel

        classname.text = className!.value(forKeyPath: "class_name") as? String
        classdesc.text = className!.value(forKeyPath: "class_decsr") as? String
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "classPalsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ClassPalsViewController{
            let obj: NSManagedObject?
            if isFiltering {
              obj = filtered[(classTable.indexPathForSelectedRow?.row)!]
            } else {
              obj = classes[(classTable.indexPathForSelectedRow?.row)!]
            }
            let classname = obj!.value(forKeyPath: "class_name") as? String
            destination.className = classname
            classTable.deselectRow(at: classTable.indexPathForSelectedRow!, animated: true)
            
        }
    }
    
    
}

//MARK: -Extenstion for search bar
extension ClassesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
