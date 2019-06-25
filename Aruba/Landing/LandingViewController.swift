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
        AuthManager.loginWithFacebook(from: self) { [weak self] loginVM, error in
            if let error = error {
                print("Failed facebook login: ", error.localizedDescription)
            } else {
                guard let self = self, let loginVM = loginVM else { return }
                let main = UIStoryboard(name: "Main", bundle: nil)
                guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController, let rootVC = dvc.viewControllers.first as? HomeTableViewController else { return }
                rootVC.viewModel = HomeViewModel(userAddresses: loginVM.addresses, user: loginVM.user.sesion.usuario)
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
