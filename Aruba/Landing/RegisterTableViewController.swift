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
    
    var acceptedTerms: Bool = false

    @IBAction func registerAction(_ sender: AButton) {
        guard let firstName = firstNameTxt.text, let lastName = lastNameTxt.text, let email = emailTxt.text, let password = passwordTxt.text else {

            return
        }
        
        guard acceptedTerms else {
            let alert = UIAlertController(title: "Atención",
                                          message: "Debes aceptar los términos y condiciones",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ver Términos", style: .default, handler: { (action) in
                if let url = URL(string: "https://aruba.com.py/terminos.php"),
                           UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url, options: [:])
                       }
            }))
            alert.addAction(UIAlertAction(title: "Acepto los Términos", style: .default, handler: { (action) in
                self.acceptedTerms = true
                self.registerAction(AButton())
            }))
            alert.view.tintColor = Colors.AlertTintColor
            alert.addAction(UIAlertAction(title: "Atras", style: .cancel, handler: nil))
            present(alert, animated: true)
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
