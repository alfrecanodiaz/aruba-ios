//
//  RegisterTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController {

    @IBOutlet weak var firstNameTxt: ATextField!
    @IBOutlet weak var lastNameTxt: ATextField!
    @IBOutlet weak var emailTxt: ATextField!
    @IBOutlet weak var passwordTxt: ATextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func registerAction(_ sender: AButton) {

        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController else { return }
        transition(to: dvc, completion: nil)
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
