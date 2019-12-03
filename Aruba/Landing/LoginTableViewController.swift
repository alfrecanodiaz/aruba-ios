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
        guard let email = emailTxt.text, let password = passwordTxt.text else { return }
        ALoader.show()
        AuthManager.login(username: email, password: password) { [weak self] (loginVM, error) in
            ALoader.hide()
            if let error = error {
                print(error.localizedDescription)
                self?.showError(title: "Lo sentimos!", message: error.localizedDescription)
            } else {
                let main = UIStoryboard(name: "Main", bundle: nil)
                guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController,
                    let rootVC = dvc.viewControllers.first as? HomeTableViewController,
                    let loginVM = loginVM,
                    let self = self else { return }
                self.transition(to: dvc, completion: nil)
            }
        }
    }

    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
