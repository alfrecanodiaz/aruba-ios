//
//  PeopleQuantiySelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class PeopleQuantiySelectionViewController: UIViewController {


    @IBOutlet weak var womenView: PeopleQuantityView!
    @IBOutlet weak var menView: PeopleQuantityView!
    @IBOutlet weak var childrenView: PeopleQuantityView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        womenView.configure(for: .Woman)
        menView.configure(for: .Men)
        childrenView.configure(for: .Children)
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
