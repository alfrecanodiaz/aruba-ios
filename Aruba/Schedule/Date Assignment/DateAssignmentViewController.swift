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

class DateAssignmentViewController: BaseViewController {
    
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
    var addressName: String!
    var addressDetails: String!
    var servicesIds: [Int] = []
    var services: [Service] = []
    var clientName: String = ""
    var category: CategoryViewModel!
    var selectedProfessional: Professional?
    var cartData: CartData?
    
    var dateSelected: Date?
    var timeSelected: Date?
    
    struct Cells {
        static let Professional = "ProfessionalCell"
    }
    
    
    struct Segues {
        static let DateAssignment = "DateAssignmentSegue"
        static let Confirmation = "showConfirmation"
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
        dateSelected = sender.date
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func timePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeSelected = sender.date
        timeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateAssignment, let dvc = segue.destination as? DateSelectionViewController {
            dvc.scheduleData = scheduleData
        }
        
        if segue.identifier == Segues.Confirmation, let dvc = segue.destination as? ConfirmViewController, let professional = selectedProfessional {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            guard let timeSelected = timeSelected else {
                return
            }
            let hourStartAsSeconds = dateFormatter.string(from: timeSelected).secondFromString
            
            
            dvc.category = category
            dvc.cartData = CartData(addressId: addressId,
                                    addressName: addressName,
                                    addressDetail: addressDetails,
                                    categoryName: category.title,
                                    services: services.map({$0.displayName}).joined(separator: ", "),
                                    clientName: clientName,
                                    fullDate: dateTextField.text! + " " + timeTextField.text!,
                                    servicesIds: servicesIds,
                                    socialReason: "",
                                    ruc: "",
                                    total: services.reduce(0, { (sum, service) in
                                        return sum + service.price
                                    }),
                                    professional: professional,
                                    hourStartAsSeconds: hourStartAsSeconds,
                                    date: dateTextField.text!)
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
        let selectedProfessional = professionals[indexPath.row]
        showProfessionalPopup(professional: selectedProfessional)
    }
    
    private func showProfessionalPopup(professional: Professional) {
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalDetailsPopupTableViewControllerID") as! ProfessionalDetailsPopupTableViewController
        
        popup.modalPresentationStyle = .popover
        popup.delegate = self
        popup.professional = professional
        popup.date = dateTextField.text
        popup.time = timeTextField.text
        let popover = popup.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = view
        popover?.sourceRect = view.bounds
        popover?.permittedArrowDirections = .init(rawValue: 0)
        addBlackBackgroundView()
        present(popup, animated: true, completion: nil)
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

extension DateAssignmentViewController: ProfessionalDetailsPopupTableViewControllerDelegate {
    func didSelectProfessional(professional: Professional) {
        removeBlackBackgroundView()
        selectedProfessional = professional
        performSegue(withIdentifier: Segues.Confirmation, sender: self)
    }
    
    func didCancelPopupForProfessional(professional: Professional) {
        removeBlackBackgroundView()
    }
    
    
}
extension String{

    var integer: Int {
        return Int(self) ?? 0
    }

    var secondFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        let seconds = components[2].integer
        return Int((hours * 60 * 60) + (minutes * 60) + seconds)
    }
}
