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
        checkUserLoggedIn()
    }
    
    private func checkUserLoggedIn() {
        if AuthManager.isLogged() {
            ALoader.show()
            AuthManager.fetchUser { (user, error) in
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
            let main = UIStoryboard(name: "Start", bundle: nil)
            guard let dvc = main.instantiateViewController(withIdentifier: "LandingViewControllerID") as? LandingViewController else { return }
            window?.rootViewController = dvc
            window?.makeKeyAndVisible()
        }
    }

}
