//
//  LandingViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

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

}
