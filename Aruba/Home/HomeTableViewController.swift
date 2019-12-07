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
    let inactiveText: String?
    
    init (category: ServiceCategory) {
        self.image = nil
        self.imageURL = category.imageURL
        self.title = category.name
        self.color = UIColor(hexRGB: category.color ?? "") ?? .green
        self.enabled = category.enabled
        self.inactiveText = category.inactiveText
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
        if categoriesViewModel.count > 0 {
            return (tableView.bounds.height - (UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)))/CGFloat(categoriesViewModel.count)
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Category, for: indexPath) as? HomeCategoryTableViewCell else { return UITableViewCell() }
        cell.configure(category: categoriesViewModel[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceCategory = categoriesViewModel[indexPath.row]
        guard serviceCategory.enabled else {
            let alert = UIAlertController(title: "Lo sentimos", message: serviceCategory.inactiveText ?? "", preferredStyle: .alert)
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
        
        guard userAddressesViewModel.count != 0 else {
            let addressesStoryboard = UIStoryboard(name: "Addresses", bundle: nil)
            let addAddressVC =  addressesStoryboard.instantiateViewController(withIdentifier: "AddAddressTableViewControllerID") as! AddAddressTableViewController
            addAddressVC.delegate = self
            present(addAddressVC, animated: true, completion: nil)
            return
        }

       showServiceCategoryPopup()
    }
    
    
    private func showServiceCategoryPopup() {
        guard let defaultAddress = userAddressesViewModel.filter({$0.isDefault}).first else { return }
        let data = ServiceCategorySelectionData(address: defaultAddress.addressFormatted, addressId: defaultAddress.id, clientName: UserManager.shared.clientName, clientType: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let popup = storyboard.instantiateViewController(withIdentifier: "ServiceCategorySelectionPopupTableViewControllerID") as? ServiceCategorySelectionPopupTableViewController else { return }
        popup.delegate = self
        popup.data = data
        popup.modalPresentationStyle = .popover
        addBlackBackgroundView()
        let popover = popup.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(popup, animated: true, completion: nil)
    }
    
    override func popupDidSelectAccept(selectedIndex: Int) {
        super.popupDidSelectAccept(selectedIndex: selectedIndex)
        popup.dismiss(animated: true) {
            self.performSegue(withIdentifier: Segues.ScheduleService, sender: self)
        }
    }
    
}

// MARK: AddAddressDelegate
extension HomeTableViewController: AddAddressDelegate {
    func didSaveAddress(address: AAddress) {
        userAddressesViewModel.append(AddressViewModel(address: address))
    }
}

// MARK: ServiceCategorySelectionDelegate
extension HomeTableViewController: ServiceCategorySelectionDelegate {
    func didPressContinue() {
        removeBlackBackgroundView()
    }
    
    func didPressCancel() {
        removeBlackBackgroundView()
    }
    
}
