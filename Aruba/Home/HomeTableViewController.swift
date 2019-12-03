//
//  HomeTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct CategoryViewModel {
    let image: UIImage?
    let imageURL: String?
    let title: String
    let color: UIColor
    let enabled: Bool
    
    init(imageName: String, title: String, color: UIColor) {
        image = UIImage(named: imageName)
        self.title = title
        self.color = color
        self.imageURL = nil
        self.enabled = true
    }
    
    init (category: ServiceCategory) {
        self.image = nil
        self.imageURL = category.imageURL
        self.title = category.name
        self.color = UIColor(hexRGB: category.color ?? "") ?? .green
        self.enabled = category.enabled
    }
}

class HomeTableViewController: BaseTableViewController {
    
    var popup: PopupTableViewController!

    
    var userAddressesViewModel: [AddressViewModel] = []
    
    var categoriesViewModel: [CategoryViewModel] = [] {
        didSet {
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            tableView.endUpdates()
        }
    }
    
    var loadedAddresses: Bool = false
    var loadedServiceCategories: Bool = false
    
    struct Cells {
        static let Category = "homeCategoryCell"
    }
    
    struct Segues {
        static let ScheduleService = "scheduleServiceSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        fetchServiceCategories()
        if AuthManager.isLogged() {
            fetchAddresses()
        }
    }
    
    private func fetchAddresses() {
        ALoader.show()
        loadedAddresses = false
        HTTPClient.shared.request(method: .POST, path: .userAddressList) { (addressList: UserAddressListResponse?, error) in
            ALoader.hide()
            if let addressList = addressList {
                self.userAddressesViewModel = addressList.data.map({AddressViewModel(address: $0)})
                self.loadedAddresses = true
            }
            self.handleFetchCompletion()
        }
    }
    
    private func fetchServiceCategories() {
        ALoader.show()
        loadedServiceCategories = false
        HTTPClient.shared.request(method: .POST, path: .serviceCategoryList) { (categoryList: ServiceCategoryListResponse?, _) in
            ALoader.hide()
            if let categories = categoryList {
                self.categoriesViewModel = categories.data.map({CategoryViewModel(category: $0)})
                self.loadedServiceCategories = true
            }
            self.handleFetchCompletion()
        }
    }
    
    private func handleFetchCompletion() {
        if AuthManager.isLogged() {
            if loadedServiceCategories && loadedAddresses {
                ALoader.hide()
            } else if loadedServiceCategories == false && loadedAddresses == false {
                
            }
        } else {
            if loadedServiceCategories {
                ALoader.hide()
            } else {
                
            }
        }
    }
    
    private func showAlertForFailedFetch() {
        let alert = UIAlertController(title: "Lo sentimos!", message: "Ocurrio un error inesperado", preferredStyle: .alert)
        let retry = UIAlertAction(title: "Reintentar", style: .default) { (_) in
            self.fetchData()
        }
        alert.addAction(retry)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.height - (UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)))/6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Category, for: indexPath) as? HomeCategoryTableViewCell else { return UITableViewCell() }
        cell.configure(category: categoriesViewModel[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceCategory = categoriesViewModel[indexPath.row]
        guard serviceCategory.enabled else {
            let alert = UIAlertController(title: "Lo sentimos", message: "Este servicio aún no se encuentra disponible.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        guard AuthManager.isLogged() else {
            let alert = UIAlertController(title: "Lo sentimos", message: "Debes registrarte para poder acceder a este servicio.", preferredStyle: .alert)
            let register = UIAlertAction(title: "Registrarme", style: .default) { (action) in
                
            }
            alert.addAction(register)
            let cancel = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }

        popup = showOptionPopup(title: "Dirección del servicio",
                                options: userAddressesViewModel.map({GenericDataCellViewModel(address: $0)}),
                                delegate: self)
    }
    
    override func popupDidSelectAccept(selectedIndex: Int) {
        super.popupDidSelectAccept(selectedIndex: selectedIndex)
        popup.dismiss(animated: true) {
            self.performSegue(withIdentifier: Segues.ScheduleService, sender: self)
        }
    }
    
}
