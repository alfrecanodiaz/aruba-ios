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

    @IBOutlet weak var facebookLoginBtn: AButton!
    @IBOutlet weak var mailLoginBtn: AButton!
    @IBOutlet weak var servicesBtn: AButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
            servicesBtn.backgroundColor = Colors.ButtonGreen
            mailLoginBtn.backgroundColor = Colors.ButtonBrown
            facebookLoginBtn.backgroundColor = Colors.ButtonGray
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
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile","email"], from: self) { [weak self] (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if result?.isCancelled ?? true {
                    print("Canceled")
                }
                guard let token = result?.token else { return }

                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = FBSDKGraphRequest.init(graphPath: "/me", parameters: params)
                let connection = FBSDKGraphRequestConnection()
                connection.add(graphRequest) { (connection, result, error) in
                    guard let info = result as? [String : AnyObject] else { return }
                    let firstName = info["first_name"] as? String ?? ""
                    let lastName = info["last_name"] as? String ?? ""
                    let email = info["email"] as? String ?? ""

                    AuthManager.registerFacebook(firstName: firstName, lastName: lastName, email: email, token: token.tokenString, completion: { (loginViewModel, error) in

                    })
                }
                connection.start()
            }
        }
    }
}
