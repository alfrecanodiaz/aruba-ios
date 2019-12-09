//
//  ProfesionalSelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfesionalSelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "ProfessionalTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.Professional)
        }
    }
    @IBOutlet weak var personLbl: UILabel!

    @IBOutlet weak var totalLbl: UILabel!
    var professionals: [Professional] = []
    var scheduleData: ScheduleData!
    var person: Person!

    struct Cells {
        static let Professional = "ProfessionalCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        totalLbl.text = scheduleData.totalPriceString()
        personLbl.text = person.gender.rawValue + " " + String(describing: person.index)

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
