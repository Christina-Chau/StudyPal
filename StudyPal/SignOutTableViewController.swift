//
//  SignOutTableViewController.swift
//  StudyPal
//
//  Created by Christina Chau on 7/5/20.
//  ID: 112720104
//  Copyright © 2020 Christina Chau. All rights reserved.
//

import UIKit

class SignOutTableViewController: UITableViewController {
    
    // MARK: -Table functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "signInIdentifier") as! SignInViewController
             navigationController?.pushViewController(vc,
             animated: true)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
