//
//  NewPalViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/30/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit

/**
 Protocol to send information from this view to the PalsViewController
 */
protocol NewPalDelegate: class{
    func passInfo(name: String, study: String, group: String)
}

class NewPalViewController: UIViewController {
    
    ///The table view to get information from
    var table: AddPalTableViewController?
    
    ///A delagate object to access
    weak var delegate: NewPalDelegate?
    
    ///The name of the class
    private var className: String?
    
    ///The study type that the user wants
    private var studyType: String?
    
    ///The group size that the user wants
    private var groupSize: String?
    
    @IBAction func findButton(_ sender: Any) {
        className = table?.classLbl.text
        studyType = table?.studyLbl.text
        groupSize = table?.groupLbl.text
        self.delegate?.passInfo(name:className!, study: studyType!, group: groupSize!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tableController = children.first as? AddPalTableViewController else {fatalError("Check storyboard for missing TableViewController")}
        table = tableController
    }

}
