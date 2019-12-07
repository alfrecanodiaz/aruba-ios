//
//  RegisterTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class RegisterTableViewController: BaseTableViewController {

    @IBOutlet weak var firstNameTxt: ATextField!
    @IBOutlet weak var lastNameTxt: ATextField!
    @IBOutlet weak var emailTxt: ATextField!
    @IBOutlet weak var passwordTxt: ATextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func registerAction(_ sender: AButton) {
        guard let firstName = firstNameTxt.text, let lastName = lastNameTxt.text, let email = emailTxt.text, let password = passwordTxt.text else {

            return
        }
        ALoader.show()
        AuthManager.registerEmail(firstName: firstName,
                                  lastName: lastName,
                                  username: email,
                                  password: password) { (loginVM, error) in
                                    ALoader.hide()
                                    if let error = error {
                                        AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
                                    } else {
                                        let main = UIStoryboard(name: "Main", bundle: nil)
                                        guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController else { return }
                                        self.showSuccess()
                                        self.transition(to: dvc, completion: nil)
                                    }
        }
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
