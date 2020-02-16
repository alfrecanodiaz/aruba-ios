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
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "ProfessionalTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.Professional)
            tableView.register(UINib(nibName: "ProfessionalScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: ProfessionalScheduleTableViewCell.Constants.reuseIdentifier)
            
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
    @IBOutlet weak var continueButton: AButton!
    
    var entryAnimationDone: Bool = false
    var scheduleData: ScheduleData!
    
    var professionals: [Professional] = [] {
        didSet {
            self.viewModel = self.professionals.sorted(by: { (pr1, pr2) -> Bool in
                guard let av1 = pr1.availableSchedules,
                    let av2 = pr2.availableSchedules,
                    let rating1 = pr1.averageReviews,
                    let rating2 = pr2.averageReviews else {
                    return false
                }
                return !av1.isEmpty ?
                    rating1 > rating2
                    : av1.count > av2.count
            }).enumerated().map {
                ProfessionalScheduleCellViewModel(
                    availableSchedules: dateRangesFrom(
                        schedules: $0.element.availableSchedules ?? [],
                        servicesTotalTime: servicesTotalTime()
                    ),
                    professionalName: $0.element.fullName(),
                    professionalAvatarUrl: $0.element.avatarURL ?? "",
                    professionalRating: Int($0.element.averageReviews ?? 0),
                    professional: $0.element,
                    index: $0.offset,
                    selectedSchedule: nil
                )
            }
        }
    }
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
    var timeSelected: Int? // amount of seconds
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    struct Cells {
        static let Professional = "ProfessionalCell"
    }
    
    
    struct Segues {
        static let DateAssignment = "DateAssignmentSegue"
        static let Confirmation = "showConfirmation"
    }
    
    enum Constants {
        static let dateCell = "DateCollectionCell"
    }
    
    var isFirstAppear: Bool = false
    
    var viewModel: [ProfessionalScheduleCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstAppear {
            dateTextField.becomeFirstResponder()
            isFirstAppear = true
        }
    }
    
    private func setupView() {
        dateTextField.text = dateFormatter.string(from: Date())
        DispatchQueue.main.async {
            self.continueButton.setEnabled(false)
        }
    }
    
    private func fetchProfessionals() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        guard let addressId = addressId, let dateText = dateTextField.text else {
            return
        }
        
        let params: [String: Any] = ["address_id": addressId, "services": servicesIds, "date": dateText]
        
        ALoader.show()
        HTTPClient.shared.request(method: .POST, path: .professionalsFilterWithAvailableSchedules, data: params) { (response: FilterProfessionalResponse?, error) in
            ALoader.hide()
            if let error = error {
                self.professionals = []
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message) {
                    self.dateTextField.becomeFirstResponder()
                }
            } else if let response = response {
                self.professionals = response.data
            }
            self.continueButton.setEnabled(false)
            self.tableView.reloadData()
        }
    }
    
    @objc private func datePickerChanged(sender: UIDatePicker) {
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateAssignment, let dvc = segue.destination as? DateSelectionViewController {
            dvc.scheduleData = scheduleData
        }
        
        if segue.identifier == Segues.Confirmation,
            let dvc = segue.destination as? ConfirmViewController,
            let professional = selectedProfessional,
            let timeSelected = timeSelected {
            dvc.cartData = CartData(addressId: addressId,
                                    addressName: addressName,
                                    addressDetail: addressDetails,
                                    categoryName: category.title,
                                    services: services.map({$0.displayName}).joined(separator: ", "),
                                    clientName: clientName,
                                    fullDate: dateTextField.text! + " " + timeSelected.asHourMinuteString(),
                                    servicesIds: servicesIds,
                                    socialReason: "",
                                    ruc: "",
                                    total: services.reduce(0, { (sum, service) in
                                        return sum + service.price
                                    }),
                                    professional: professional,
                                    hourStartAsSeconds: timeSelected,
                                    date: dateTextField.text!,
                                    categoryImageUrl: category.imageURL ?? "")
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.Confirmation, sender: self)
    }
}

extension DateAssignmentViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfessionalScheduleTableViewCell.Constants.reuseIdentifier,
            for: indexPath
            ) as! ProfessionalScheduleTableViewCell
        cell.viewModel = viewModel[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dateTextField.resignFirstResponder()
        let selectedProfessional = viewModel[indexPath.row].professional
        var hourSelected: String = ""
        if let selectedSchedule = viewModel[indexPath.row].selectedSchedule {
            hourSelected = viewModel[indexPath.row].availableSchedules[selectedSchedule].asHourMinuteString()
        }
        showProfessionalPopup(professional: selectedProfessional, hourString: hourSelected)
    }
    
    private func servicesTotalTime() -> Int {
        services.reduce(0) { result, service in
            result + service.duration
        }
    }
    
    private func dateRangesFrom(schedules: [AvailableSchedule], servicesTotalTime: Int) -> [Int] {
        schedules.map {
            makeRangesFor(hourStart: $0.hourStart,
                          hourEnd: $0.hourEnd - servicesTotalTime,
                          divideAmount: 30*60)
        }.reduce([Int]()) { result, value  in
            result + value
        }
    }
    
    /// Generate an array with date ranges splitted with the specified `divideAmount`
    /// - Parameter divideAmount: amount of seconds into which to split the dates
    private func makeRangesFor(hourStart: Int, hourEnd: Int, divideAmount: Int) -> [Int] {
        var difference = hourEnd - hourStart
        var ranges: [Int] = []
        while difference >= divideAmount {
            ranges.append((hourEnd - difference))
            difference = difference - divideAmount
        }
        return ranges.sorted()
    }
    
    private func showProfessionalPopup(professional: Professional, hourString: String) {
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalDetailsPopupTableViewControllerID") as! ProfessionalDetailsPopupTableViewController
        
        popup.modalPresentationStyle = .popover
        popup.delegate = self
        popup.professional = professional
        popup.date = dateTextField.text
        popup.time =  hourString
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

extension DateAssignmentViewController: ProfessionalScheduleTableViewCellDelegate {
    
    func didChangeSelectedSchedules(index: Int, selectedSchedule: Int?) {
        for ind in 0...(viewModel.count - 1) {
            self.viewModel[ind].selectedSchedule = nil
        }
        self.viewModel[index].selectedSchedule = selectedSchedule
        selectedProfessional = self.viewModel[index].professional
        continueButton.setEnabled(selectedSchedule != nil)
        if let selectedSchedule = selectedSchedule {
            self.timeSelected = self.viewModel[index].availableSchedules[selectedSchedule]
        } else {
            self.timeSelected = nil
        }
        self.tableView.reloadData()
    }
    
}
