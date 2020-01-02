//
//  ProfessionalsTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/2/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfessionalsTableViewController: UITableViewController {
    
    // Inject in prepareForSegue
    var serviceCategoryId: Int!
    
    var viewModel: [Professional] = [] {
        didSet {
            if viewModel.isEmpty {
                tableView.backgroundView = viewForEmptyState(text: "No hay profesionales para esta categoria")
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
        }
    }
    
    var filteredViewModel: [Professional] = [] {
        didSet {
            tableView.reloadData()
            if filteredViewModel.count == 0 {
                let label = UILabel()
                label.text = "No hay profesionales con ese nombre para esta categoria"
                label.font = AFont.with(size: 19, weight: .bold)
                label.sizeToFit()
                label.numberOfLines = 0
                label.textAlignment = .center
                self.tableView.backgroundView = label
            } else {
                self.tableView.backgroundView = nil
            }
        }
    }
    
    var searching: Bool = false
    
    var spinner = UIActivityIndicatorView() {
        didSet {
            spinner.hidesWhenStopped = true
            spinner.tintColor = Colors.ButtonGreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ProfessionalListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfessionalListCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundView = spinner
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        fetchProfessionals()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? filteredViewModel.count : viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalListCell", for: indexPath) as? ProfessionalListTableViewCell else {
            return UITableViewCell()
        }
        let professional = searching ? filteredViewModel[indexPath.row] : viewModel[indexPath.row]
        cell.configure(professional: professional)
        return cell
    }
    
    private func fetchProfessionals() {
        spinner.startAnimating()
        let params: [String: Any] = ["service_category_id": serviceCategoryId]
        HTTPClient.shared.request(method: .POST, path: .professionalsFilter, data: params) { (response: FilterProfessionalResponse?, error) in
            self.spinner.stopAnimating()
            if let error = error {
                self.tableView.backgroundView = self.viewForEmptyState(text: error.message)
            } else if let response = response {
                self.viewModel = response.data
            }
        }
    }
    
    private func viewForEmptyState(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = AFont.with(size: 19, weight: .bold)
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    
}
