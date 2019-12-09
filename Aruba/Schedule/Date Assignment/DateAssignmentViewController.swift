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
            tableView.tableFooterView = nil
            tableView.register(UINib(nibName: "ProfessionalTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.Professional)

        }
    }
    
    @IBOutlet weak var dateTextField: ATextField! {
        didSet {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
        
            datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
            dateTextField.aDelegate = self
            dateTextField.inputView = datePicker
        }
    }
    @IBOutlet weak var timeTextField: ATextField! {
        didSet {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            datePicker.minuteInterval = 15
            timeTextField.aDelegate = self
            datePicker.addTarget(self, action: #selector(timePickerChanged(sender:)), for: .valueChanged)
            timeTextField.inputView = datePicker
        }
    }
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var entryAnimationDone: Bool = false
    var scheduleData: ScheduleData!
    
    var professionals: [Professional] = []
    var addressId: Int!
    var servicesIds: [Int] = []
    var clientName: String = ""
    var category: CategoryViewModel!
    
    struct Cells {
        static let Professional = "ProfessionalCell"
    }

    
    struct Segues {
        static let DateAssignment = "DateAssignmentSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        clientLabel.text = "¡Hola \(clientName)!"
        categoryLabel.text = "Estas en la categoria \(category.title.uppercased())"
    }
    
    private func fetchProfessionals() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        guard let addressId = addressId, let dateText = dateTextField.text,
            let timeText = timeTextField.text, let timeDate = dateFormatter.date(from: timeText) else {
            return
        }
        
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: timeDate)
        let minutes = calendar.component(.minute, from: timeDate)
        let hourStart: Int = hour*60*60 + minutes*60
        
        let params: [String: Any] = ["address_id": addressId, "services": servicesIds, "hour_start": hourStart, "date": dateText]
        
        ALoader.show()
        HTTPClient.shared.request(method: .POST, path: .professionalsFilter, data: params) { (response: FilterProfessionalResponse?, error) in
            ALoader.hide()
            if let error = error {
                self.professionals = []
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
            } else if let response = response {
                self.professionals = response.data
            }
            self.tableView.reloadData()
        }
    }
    
    @objc private func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func timePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateAssignment, let dvc = segue.destination as? DateSelectionViewController {
            dvc.scheduleData = scheduleData
            
        }
    }
    
}

extension DateAssignmentViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professionals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Professional, for: indexPath) as! ProfessionalTableViewCell
        cell.configure(professional: professionals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        return professionals.isEmpty ? "" : "Profesionales"
    }
    
}

extension DateAssignmentViewController: ATextFieldDelegate {
    
    func didPressDone(textField: ATextField) {
        fetchProfessionals()
    }
}
