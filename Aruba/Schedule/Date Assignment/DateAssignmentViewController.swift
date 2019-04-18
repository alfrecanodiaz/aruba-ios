//
//  DateAssignmentViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/9/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct Person {
    let gender: Gender
    var scheduleProducts: [Product] = []
    var scheduleDate: ScheduleDate?
    var index: Int = 1
    
    enum Gender: String {
        case Women = "MUJER", Children = "NIÑO", Man = "HOMBRE"
        
        var image: UIImage {
            switch self {
            case .Women:
                return #imageLiteral(resourceName: "women")
            case .Children:
                return #imageLiteral(resourceName: "women")
            case .Man:
                return #imageLiteral(resourceName: "women")
            }
        }
    }
    
    init(gender: Gender, index: Int) {
        self.gender = gender
        self.index = index
    }
    
    
}

struct ScheduleData {
    let persons: [Person]
    
    func totalPriceString() -> String? {
        var total: Double = 0
        
        for person in self.persons {
            for product in person.scheduleProducts {
                total = total + product.price
            }
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_PY")
        return formatter.string(from: NSNumber(value: total))
    }
}

struct ScheduleDate {
    
}

class DateAssignmentViewController: UIViewController {

    var entryAnimationDone: Bool = false
    
    var scheduleData: ScheduleData!
    private var remainingPersons: [Person] = []
    private var configuredPersons: [Person] = []
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
        // TODO: remove configured person from remaining person array
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
        return configuredPersons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.DateAssignment, for: indexPath) as! DateAssignmentTableViewCell
        
        if indexPath.section == 0 {
            cell.configure(person: remainingPersons[indexPath.row], scheduled: false)
        } else {
            cell.configure(person: configuredPersons[indexPath.row], scheduled: true)
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
        if !entryAnimationDone {
            cell.transform = CGAffineTransform(translationX: 0, y: 40)
            cell.alpha = 0
            UIView.animate(withDuration: 0.3, delay: TimeInterval(0.1*Double(indexPath.row)), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }) { (end) in
                self.entryAnimationDone = true
            }
        }
    }
    
    
}
