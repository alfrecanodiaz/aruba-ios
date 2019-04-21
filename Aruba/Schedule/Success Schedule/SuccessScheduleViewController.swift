//
//  SuccessScheduleViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/21/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class SuccessScheduleViewController: UIViewController {

    struct Segues {
        static let UnwindToDateAssignment = "unwindToDateAssignment"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextAction(_ sender: AButton) {
        self.performSegue(withIdentifier: Segues.UnwindToDateAssignment, sender: self)
    }

}
