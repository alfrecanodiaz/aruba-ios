//
//  ProfesionalSelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct Professional {
    
}

class ProfesionalSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "ProfessionalTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.Professional)
        }
    }
    
    var professionals: [Professional] = []
    
    
    struct Cells {
        static let Professional = "ProfessionalCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        professionals = [Professional(),Professional(),Professional(),Professional(),Professional(),Professional(),Professional(),Professional()]
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

extension ProfesionalSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professionals.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Professional, for: indexPath) as! ProfessionalTableViewCell
        
        return cell
    }
    
    
}