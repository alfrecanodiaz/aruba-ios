//
//  HistoryViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/26/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    var appointments: [Appointment] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    enum Cells {
        static let History = "HistoryCell"
    }
    
    enum Segues {
        static let Detail = "ShowDetail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: Cells.History)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAppointments()
    }
    
    private func fetchAppointments() {
        ALoader.show()
        HTTPClient.shared.request(method: .POST, path: .appointments, data: nil) { (response: UserAppointmentList?, error) in
            ALoader.hide()
            if let response = response {
                self.appointments = response.data.data
            } else if let error = error {
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message) {
                    self.fetchAppointments()
                }
            }
        }
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

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.History, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(viewModel: HistoryTableViewCellViewModel(appointment: appointments[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedAppointment = appointments[indexPath.row]
        guard let detailsVC = storyboard?
            .instantiateViewController(withIdentifier: "HistoryDetailsViewControllerID") as? HistoryDetailsViewController else { return }
        detailsVC.viewModel = HistoryDetailsViewModel(appointment: selectedAppointment)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
