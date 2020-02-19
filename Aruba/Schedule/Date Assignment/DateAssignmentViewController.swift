//
//  DateAssignmentViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/9/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateAssignmentViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = nil
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "ProfessionalTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.Professional)
            tableView.register(UINib(nibName: "ProfessionalScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: ProfessionalScheduleTableViewCell.Constants.reuseIdentifier)
            
        }
    }

    @IBOutlet weak var calendarView: JTACMonthView! {
        didSet {
            calendarView.scrollingMode = .stopAtEachCalendarFrame
            calendarView.showsHorizontalScrollIndicator = false
            calendarView.layer.borderColor = Colors.Greens.borderLine.cgColor
            calendarView.layer.borderWidth = 1
            calendarView.layer.cornerRadius = 5
            calendarView.clipsToBounds = true
            calendarView.allowsRangedSelection = false
            calendarView.allowsMultipleSelection = false
        }
    }
    @IBOutlet weak var bottomTotalContainerView: UIView!
    
    var entryAnimationDone: Bool = false
    var scheduleData: ScheduleData!
    
    lazy var onlyDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    lazy var onlyMonthAndYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
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
        static let Cart = "showCart"
    }
    
    enum Constants {
        static let dateCell = "DateCollectionCell"
    }
    
    var isFirstAppear: Bool = false
    
    var viewModel: [ProfessionalScheduleCellViewModel] = []
    private var selectedDate: Date = Date()
    private let initialDate = Date()
    
    lazy var bottomTotalView: BottomTotalView = {
        BottomTotalView.build(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupCalendar()
        setupBottomView()
    }
    
    private func setupBottomView() {
        self.bottomTotalContainerView.addSubview(bottomTotalView)
        bottomTotalView.constraintToSuperView()
        bottomTotalView.totalLabel.text = "Total:    \(servicesTotalPrice())"
    }
    
    private func setupCalendar() {
        calendarView.selectDates([initialDate])
        calendarView.scrollToDate(initialDate)
        selectedDate = initialDate
        fetchProfessionals()
    }

    
    private func fetchProfessionals() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d-MM-Y"
        
        guard let addressId = addressId else {
                return
        }
        let dateText = dateFormatter.string(from: selectedDate)
        let params: [String: Any] = [
            "address_id": addressId,
            "services": servicesIds,
            "date": dateText
        ]
        
        ALoader.showCalendarLoader()
        HTTPClient.shared.request(method: .POST, path: .professionalsFilterWithAvailableSchedules, data: params) { (response: FilterProfessionalResponse?, error) in
            ALoader.hideCalendarLoader()
            if let error = error {
                self.professionals = []
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
            } else if let response = response {
                self.professionals = response.data
            }
            self.bottomTotalView.continueButton.setEnabled(false)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateAssignment, let dvc = segue.destination as? DateSelectionViewController {
            dvc.scheduleData = scheduleData
        }
        
        if segue.identifier == Segues.Cart,
            let dvc = segue.destination as? CartViewController,
            let professional = selectedProfessional,
            let timeSelected = timeSelected {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let date = formatter.string(from: selectedDate)
            dvc.cartData = CartData(addressId: addressId,
                                    addressName: addressName,
                                    addressDetail: addressDetails,
                                    categoryName: category.title,
                                    services: services.map({$0.displayName}).joined(separator: ", "),
                                    clientName: clientName,
                                    fullDate: date + " " + timeSelected.asHourMinuteString(),
                                    servicesIds: servicesIds,
                                    socialReason: "",
                                    ruc: "",
                                    total: services.reduce(0, { (sum, service) in
                                        return sum + service.price
                                    }),
                                    professional: professional,
                                    hourStartAsSeconds: timeSelected,
                                    date: date,
                                    categoryImageUrl: category.imageURL ?? "")
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.Confirmation, sender: self)
    }
    
    private func servicesTotalTime() -> Int {
        services.reduce(0) { result, service in
            result + service.duration
        }
    }
    
    private func servicesTotalPrice() -> String {
        services.reduce(0, { (sum, service) in
            return sum + service.price
            }).asGs() ?? ""
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl = UILabel()
        lbl.text = "Profesionales disponibles"
        lbl.textColor = Colors.Greens.professionalListHeader
        lbl.font = AFont.with(size: 14, weight: .bold)
        lbl.sizeToFit()
        lbl.backgroundColor = .white
        return lbl
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
        let selectedProfessional = viewModel[indexPath.row].professional
        var hourSelected: String = ""
        if let selectedSchedule = viewModel[indexPath.row].selectedSchedule {
            hourSelected = viewModel[indexPath.row].availableSchedules[selectedSchedule].asHourMinuteString()
        }
        showProfessionalPopup(professional: selectedProfessional, hourString: hourSelected)
    }
    
    private func dateRangesFrom(schedules: [AvailableSchedule], servicesTotalTime: Int) -> [Int] {
        return schedules.map {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return professionals.isEmpty ? 0 : 16
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
        self.bottomTotalView.continueButton.setEnabled(selectedSchedule != nil)
        if let selectedSchedule = selectedSchedule {
            self.timeSelected = self.viewModel[index].availableSchedules[selectedSchedule]
        } else {
            self.timeSelected = nil
        }
        self.tableView.reloadData()
    }
    
}

// MARK: JTACMonthViewDataSource & JTACMonthViewDelegate
extension DateAssignmentViewController: JTACMonthViewDataSource, JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard var cell = cell as? CalendarDayCollectionViewCell else { return }
        configureCell(cell: &cell, text: cellState.text, date: date, isSelected: cellState.isSelected)
    }
    
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let year = Calendar.current.component(.year, from: selectedDate)
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)),
            let endDate = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear) {
            return ConfigurationParameters(
                startDate: selectedDate,
                endDate: endDate,
                numberOfRows: 1,
                generateInDates: .off,
                generateOutDates: .tillEndOfGrid,
                hasStrictBoundaries: true
            )
        }
        return ConfigurationParameters(startDate: Date(), endDate: Date(), numberOfRows: 1)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        var cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarDayReuseId", for: indexPath) as! CalendarDayCollectionViewCell
        configureCell(cell: &cell, text: cellState.text, date: date, isSelected: cellState.isSelected)
        return cell
    }
    
    func configureCell(cell: inout CalendarDayCollectionViewCell, text: String, date: Date, isSelected: Bool) {
        cell.dateLabel.text = text
        cell.backgroundRoundView.layer.cornerRadius = cell.backgroundRoundView.bounds.width / 2
        cell.backgroundRoundView.clipsToBounds = true
        cell.dayNameLabel.text = onlyDayFormatter.string(from: date)
        cell.setSelected(isSelected)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDayCollectionViewCell else { return }
        selectedDate = date
        cell.setSelected(true)
        fetchProfessionals()
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        if cellState.isSelected {
            return false
        }
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedAscending {
            return Calendar.current.compare(date, to: Date(), toGranularity: .month) == .orderedDescending
        } else {
            return Calendar.current.compare(date, to: Date(), toGranularity: .month) == .orderedSame ||
             Calendar.current.compare(date, to: Date(), toGranularity: .month) == .orderedDescending
        }
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "dateHeaderReuseId", for: indexPath) as! CalendarDayHeaderCollectionViewCell
        
        header.monthTitle.text = onlyMonthAndYearFormatter.string(from: range.start)
        return header
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDayCollectionViewCell else { return }
        cell.setSelected(false)
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
    
    func scrollDidEndDecelerating(for calendar: JTACMonthView) {
        let visibleDates = calendarView.visibleDates()
        let dateWeShouldNotCross = initialDate
        let dateToScrollBackTo = initialDate
        if visibleDates.monthDates.contains (where: {$0.date <= dateWeShouldNotCross}) {
            calendarView.scrollToDate(dateToScrollBackTo)
            return
        }
    }
}

class CalendarDayHeaderCollectionViewCell: JTACMonthReusableView  {
    @IBOutlet var monthTitle: UILabel!
}

extension DateAssignmentViewController: BottomTotalViewDelegate {
    func didSelectContinue(view: BottomTotalView) {
        performSegue(withIdentifier: Segues.Cart, sender: self)
    }
    
}

extension UIView {
    func constraintToSuperView() {
        guard let superView = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
        ])
    }
}
