//
//  SplashLoaderViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/3/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class SplashLoaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserLoggedIn()
    }
    
    private func checkUserLoggedIn() {
        if AuthManager.isLogged() {
            ALoader.show()
            AuthManager.fetchUser { (user, error) in
                UserManager.shared.getTaxInfo { (error) in }
                UserManager.shared.listDevices { devices, error in }
                ALoader.hide()
                if error == nil {
                    let window = UIApplication.shared.keyWindow
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    guard let dvc = main.instantiateViewController(withIdentifier: "BaseNavigationControllerID") as? BaseNavigationController else { return }
                    window?.rootViewController = dvc
                    window?.makeKeyAndVisible()
                } else {
                    AlertManager.showNotice(in: self, title: "Lo sentimos", description: error?.message ?? "Ocurrio un error inesperado.") {
                        self.checkUserLoggedIn()
                    }
                }
            }
        } else {
            let window = UIApplication.shared.keyWindow
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            guard let dvc = storyboard.instantiateViewController(withIdentifier: "LandingViewControllerID") as? LandingViewController else { return }
            window?.rootViewController = dvc
            window?.makeKeyAndVisible()
        }
    }

}
