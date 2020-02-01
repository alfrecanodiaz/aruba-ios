//
//  LoginTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/26/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class LoginTableViewController: BaseTableViewController {

    @IBOutlet weak var emailTxt: ATextField!
    @IBOutlet weak var passwordTxt: ATextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }

    private func setupTable() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    @IBAction func loginAction(_ sender: AButton) {
        guard let email = emailTxt.text, !email.isEmpty,
            let password = passwordTxt.text, !password.isEmpty else { return }
        tableView.endEditing(true)
        ALoader.show()
        AuthManager.login(username: email, password: password) { [weak self] (loginVM, error) in
            ALoader.hide()
            if let error = error {
                self?.showError(title: "Lo sentimos!", message: error.message)
            } else {
                let main = UIStoryboard(name: "Main", bundle: nil)
                guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController,
                    let self = self else { return }
                self.transition(to: dvc, completion: nil)
            }
        }
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        guard let email = emailTxt.text, !email.isEmpty else { return }
        tableView.endEditing(true)
        ALoader.show()
        AuthManager.resetPassword(email: email) { (message, error) in
            ALoader.hide()
            if let message = message {
                AlertManager.showNotice(in: self, title: "¡Listo!", description: message)
            } else if let error = error {
                AlertManager.showErrorNotice(in: self, error: error)
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
