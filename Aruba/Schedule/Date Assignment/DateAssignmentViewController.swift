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
    @IBOutlet weak var dateCollectionView: UICollectionView! {
        didSet {
            dateCollectionView.dataSource = self
            dateCollectionView.delegate = self
        }
    }
    
    var entryAnimationDone: Bool = false
    var scheduleData: ScheduleData!
    
    var professionals: [Professional] = [] {
        didSet {
            self.viewModel = self.professionals.enumerated().map {
                ProfessionalScheduleCellViewModel(
                    availableSchedules: dateRangesFrom(
                        schedules: $0.element.availableSchedules,
                        servicesTotalTime: servicesTotalTime()
                    ),
                    professionalName: $0.element.fullName(),
                    professionalAvatarUrl: $0.element.avatarURL ?? "",
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
    var timeSelected: Date?
    
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
    
    var viewModel: [ProfessionalScheduleCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateTextField.becomeFirstResponder()
    }
    
    private func setupView() {
        dateTextField.text = dateFormatter.string(from: Date())
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
        HTTPClient.shared.request(method: .POST, path: .professionalsFilterWithAvailableSchedules, data: params) { (response: FilterProfessionalResponse?, error) in
            ALoader.hide()
            if let error = error {
                self.professionals = []
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message) {
                    self.timeTextField.becomeFirstResponder()
                }
            } else if let response = response {
                self.professionals = response.data
            }
            self.tableView.reloadData()
        }
    }
    
    @objc private func datePickerChanged(sender: UIDatePicker) {
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
                                    date: dateTextField.text!,
                                    categoryImageUrl: category.imageURL ?? "")
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfessionalScheduleTableViewCell.Constants.reuseIdentifier, for: indexPath) as! ProfessionalScheduleTableViewCell
        //        cell.configure(professional: professionals[indexPath.row])

        cell.viewModel = viewModel[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dateTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        let selectedProfessional = professionals[indexPath.row]
        showProfessionalPopup(professional: selectedProfessional)
    }
    
    private func servicesTotalTime() -> Int {
        services.reduce(0) { result, service in
            result + service.duration
        }
    }
    
    private func dateRangesFrom(schedules: [AvailableSchedule], servicesTotalTime: Int) -> [String] {
        schedules.map {
            makeRangesFor(hourStart: $0.hourStart, hourEnd: $0.hourEnd - servicesTotalTime, divideAmount: 30*60)
        }.reduce([String]()) { result, value  in
            result + value
        }
    }
    
    /// Generate an array with date ranges splitted with the specified parameters
    /// - Parameter divideAmount: amount of seconds into which to split the dates
    private func makeRangesFor(hourStart: Int, hourEnd: Int, divideAmount: Int) -> [String] {
        var difference = hourEnd - hourStart
        var ranges: [String] = []
        while difference >= 0 {
            ranges.append((hourEnd - difference).asHourMinuteString())
            difference = difference - divideAmount
        }
        return ranges.sorted()
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
        if timeTextField.text == nil || timeTextField.text == "" {
            timeTextField.becomeFirstResponder()
            return
        }
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

extension Int {
    /// Convert a seconds int to a human readable hour minute string
    func asHourMinuteString() -> String {
        let hours = Int(floor(Double(self/60/60)))
        let minutes = self/60 - hours*60
        var hoursString: String = "\(hours)"
        var minutesString: String = "\(minutes)"
        if minutes < 10 {
            minutesString = "0\(minutesString)"
        }
        if hours < 10 {
            hoursString = "0\(hoursString)"
        }
        return hoursString + ":" + minutesString
    }
}

extension DateAssignmentViewController: ProfessionalScheduleTableViewCellDelegate {
    
    func didChangeSelectedSchedules(index: Int, selectedSchedule: Int?) {
        self.viewModel[index].selectedSchedule = selectedSchedule
    }
    
    
}

extension DateAssignmentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.dateCell,
                                                      for: indexPath) as? DateCollectionViewCell
        cell?.dateLabel.text = "\(indexPath.row)"
        return cell ?? UICollectionViewCell()
    }
    
}
