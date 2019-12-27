//
//  ServiceSelectionViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ServiceSelectionViewController: BaseViewController {

    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var subCategorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var continueBtn: AButton!

    struct Cells {
        static let ServiceSelection = "ServiceSelectionCell"
    }

    struct Segues {
        static let DateSelection = "showDateSelectionSegue"
        static let Popup = "presentPopup"
        static let ProductPopup = "showProductPopover"
    }
    
    var category: CategoryViewModel!
    var services: [[Service]] = []
    var clientName: String = ""
    var servicesDisplaying: [Service] = []
    var addressName: String!
    var addressDetails: String!
    var addressId: Int!
    
    private var selectedServices: [[IndexPath]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchServices()
    }

    func setupView() {
        tableView.register(UINib(nibName: "ServiceSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ServiceSelection)
        tableView.tableFooterView = nil
        tableView.dataSource = self
        tableView.delegate = self
        subCategorySegmentedControl.removeAllSegments()
        
        for cat in category.subCategories.reversed() where cat.enabled {
            subCategorySegmentedControl.insertSegment(withTitle: cat.title.uppercased(), at: 0, animated: false)
            services.insert([], at: 0)
            selectedServices.insert([], at: 0)
        }
        
        clientLabel.text = "¡Hola \(clientName)!"
        categoryLabel.text = "Estas en la categoria \(category.title.uppercased())"
        
        continueBtn.setEnabled(false)
    }
    
    private func fetchServices() {
        ALoader.show()
        var params: [String: Any] = [:]
        if category.subCategories.isEmpty {
            params = ["categories":[category.id]]
        } else {
            params = ["categories":category.subCategories.map({$0.id})]
        }
        HTTPClient.shared.request(method: .POST, path: .servicesList, data: params) { (response: ServicesListResponse?, error) in
            ALoader.hide()
            if let error = error {
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message) {
                    self.fetchServices()
                }
            } else if let response = response {
                for service in response.data {
                    guard let serviceCategories = service.categories else { return }
                    for cat in serviceCategories {
                        for (index, cat2) in self.category.subCategories.enumerated() {
                            if cat.id == cat2.id {
                                self.services[index].insert(service, at: 0)
                            }
                        }
                    }
                }
                self.subCategorySegmentedControl.selectedSegmentIndex = 0
                self.servicesDisplaying = self.services[0]
                self.tableView.reloadData()
            }
        }

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.DateSelection {
            let dvc = segue.destination as! DateAssignmentViewController
            dvc.addressId = addressId
            
            var servicesIds:[Int] = []
            var servicesSelected:[Service] = []

            for (index, selectedService) in selectedServices.enumerated() {
                servicesSelected += selectedService.map({services[index][$0.row]})
                servicesIds += selectedService.map({services[index][$0.row].id})
            }
            dvc.services = servicesSelected
            dvc.servicesIds = servicesIds
            dvc.category = category
            dvc.clientName = clientName
            dvc.addressName = addressName
            dvc.addressDetails = addressDetails
            dvc.category = category
        }
        if segue.identifier == Segues.Popup {

        }
    }

    private func setupView(for person: Person) {
        tableView.reloadData()
        continueBtn.setEnabled(false)
        calculateTotal()
    }

    public func showServiceDescriptionPopup(indexPath: IndexPath, segmentedIndex: Int) {
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "ProductDescriptionPopupTableViewControllerID") as! ProductDescriptionPopupTableViewController
        let service = servicesDisplaying[indexPath.row]
        popup.service = service
        popup.segmentedIndex = segmentedIndex
        popup.indexPath = indexPath
        popup.modalPresentationStyle = .popover
        let popover = popup.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = view
        popover?.sourceRect = view.bounds
        popover?.permittedArrowDirections = .init(rawValue: 0)

        popup.delegate = self
        addBlackBackgroundView()
        present(popup, animated: true, completion: nil)
    }
    
    
    @IBAction func subCategorySegmentedControlChanged(_ sender: UISegmentedControl) {
        servicesDisplaying = services[sender.selectedSegmentIndex]
        tableView.reloadData()
    }
    
}

extension ServiceSelectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesDisplaying.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ServiceSelection, for: indexPath) as? ServiceSelectionTableViewCell else { return UITableViewCell() }

        let index = subCategorySegmentedControl.selectedSegmentIndex
        let service = servicesDisplaying[indexPath.row]
        let selectedIndexes = selectedServices[index]
        cell.configure(service: service,
                       isSelected: selectedIndexes.contains(indexPath),
                       indexPath: indexPath)

        cell.delegate = self
        return cell
    }

    private func calculateTotal() {
        var total: Int = 0
        for (index, service) in selectedServices.enumerated() {
            for indexPath in service {
                total = services[index][indexPath.row].price + total
            }
        }
        totalLbl.text = total.asGs()
    }
    
    private func updateScreenForServiceUpdate() {
        var hasSelection: Bool = false
        for service in selectedServices {
            if hasSelection {
                break
            }
            hasSelection = !service.isEmpty
        }
        continueBtn.setEnabled(hasSelection)
        calculateTotal()
    }

}

extension ServiceSelectionViewController: ServiceSelectionTableViewCellDelegate {
    
    func didSelectViewProductDescription(at indexPath: IndexPath) {
        let segmentedIndex = subCategorySegmentedControl.selectedSegmentIndex
        showServiceDescriptionPopup(indexPath: indexPath, segmentedIndex: segmentedIndex)
    }

    func didSelectProduct(selected: Bool, at indexPath: IndexPath) {
        let selectedSegment = subCategorySegmentedControl.selectedSegmentIndex
        if selected {
            selectedServices[selectedSegment].append(indexPath)
        } else {
            guard let index =  selectedServices[selectedSegment].firstIndex(of: indexPath) else { return }
            selectedServices[selectedSegment].remove(at: index)
        }

        updateScreenForServiceUpdate()
    }
}

extension ServiceSelectionViewController: ProductPopupDelegate {
    
    func didSelectService(service: Service, segmentedIndex: Int, indexPath: IndexPath) {
        if !selectedServices[segmentedIndex].contains(indexPath) {
            selectedServices[segmentedIndex].append(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateScreenForServiceUpdate()
        removeBlackBackgroundView()
    }

}
