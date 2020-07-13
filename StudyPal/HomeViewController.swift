//
//  HomeViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 6/26/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var usernameLbl: UILabel!
    
    /// The user's username
    var username: String?
    
    override func viewDidLoad() {
        username = usernameFinal
        usernameLbl.text = username! + "!"
        super.viewDidLoad()
    }
}
