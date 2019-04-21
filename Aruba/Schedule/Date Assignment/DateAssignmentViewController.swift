//
//  DateAssignmentViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/9/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct ScheduleDate {

}

class DateAssignmentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }

    var entryAnimationDone: Bool = false
    var scheduleData: ScheduleData!

    private var remainingPersons: [Person] = []
    private var scheduledPersons: [Person] = []
    private var selectedPerson: Person!

    struct Cells {
        static let DateAssignment = "dateAssignmentCell"
    }

    struct Segues {
        static let DateAssignment = "DateAssignmentSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        remainingPersons = scheduleData.persons
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateAssignment, let dvc = segue.destination as? DateSelectionViewController {
            dvc.scheduleData = scheduleData
            dvc.person = selectedPerson
        }
    }

    @IBAction func  unwindToDateAssignmentSegue(segue: UIStoryboardSegue) {
        remainingPersons.removeAll { (person) -> Bool in
            person.id == selectedPerson.id
        }
        scheduledPersons.append(selectedPerson)
        selectedPerson = nil
        tableView.reloadData()
    }
}

extension DateAssignmentViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return remainingPersons.count
        }
        return scheduledPersons.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.DateAssignment, for: indexPath) as? DateAssignmentTableViewCell else { return UITableViewCell() }

        if indexPath.section == 0 {
            cell.configure(person: remainingPersons[indexPath.row], scheduled: false)
        } else {
            cell.configure(person: scheduledPersons[indexPath.row], scheduled: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            selectedPerson = remainingPersons[indexPath.row]
            self.performSegue(withIdentifier: Segues.DateAssignment, sender: self)

        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let completion: ((Bool) -> Void) = { _ in
            self.entryAnimationDone = true
        }
        if !entryAnimationDone {
            cell.transform = CGAffineTransform(translationX: 0, y: 40)
            cell.alpha = 0
            UIView.animate(withDuration: 0.3, delay: TimeInterval(0.1*Double(indexPath.row)), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }, completion: completion)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Por Agendar"
        }
        if scheduledPersons.isEmpty {
            return nil
        }
        return "Agendados"
    }

}
