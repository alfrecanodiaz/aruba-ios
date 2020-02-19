//
//  LandingViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LandingViewController: UIViewController {
    
    @IBOutlet weak var facebookLoginBtn: AButton! {
        didSet {
            facebookLoginBtn.buttonColor = Colors.ButtonGray
            facebookLoginBtn.highlightColor = Colors.ButtonGray
        }
    }
    
    @IBOutlet weak var mailLoginBtn: AButton! {
        didSet {
            mailLoginBtn.buttonColor = Colors.ButtonBrown
            mailLoginBtn.highlightColor = Colors.ButtonBrown
        }
    }
    
    @IBOutlet weak var servicesBtn: AButton!
    
    private var acceptedTerms: Bool {
        get {
            UserDefaults.standard.bool(forKey: "UserAcceptedTermsKey")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UserAcceptedTermsKey")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthManager.logout()
        setupView()
    }
    
    func setupView() {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func facebookAction(_ sender: AButton) {
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
                self.facebookAction(self.facebookLoginBtn)
            }))
            alert.addAction(UIAlertAction(title: "Atras", style: .cancel, handler: nil))
            alert.view.tintColor = Colors.AlertTintColor
            present(alert, animated: true)
            return
        }
        ALoader.show()
        AuthManager.loginWithFacebook(from: self) { [weak self] loginVM, errorString in
            guard let self = self else { return }
            ALoader.hide()
            if let errorString = errorString {
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: errorString)
            } else {
                let main = UIStoryboard(name: "Main", bundle: nil)
                guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController else { return }
                self.transition(to: dvc, completion: nil)
            }
        }
    }
    
    @IBAction func servicesAction(_ sender: AButton) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController else { return }
        self.transition(to: dvc, completion: nil)
    }
    
}
