//
//  SettingsViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 7/5/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        usernameLbl.text = usernameFinal
        super.viewDidLoad()
    }

}
