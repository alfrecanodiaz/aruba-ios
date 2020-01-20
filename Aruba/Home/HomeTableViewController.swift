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
    var subCategories: [CategoryViewModel]
    let clientTypes: [ClientType]
    let id: Int
    
    init (category: ServiceCategory) {
        self.image = nil
        self.imageURL = category.imageURL
        self.title = category.displayName
        self.color = UIColor(hexRGB: category.color ?? "") ?? .green
        self.enabled = category.enabled
        self.inactiveText = category.inactiveText
        if let subCategories = category.subCategories {
            self.subCategories = subCategories.map({CategoryViewModel(category: $0)})
        } else {
            subCategories = []
        }
        self.clientTypes = category.clientTypes ?? []
        self.id = category.id
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
    var selectedCategory: CategoryViewModel?
    var selectedClientName: String = ""
    var selectedAddressId: Int?
    var addressName: String?
    var addressDetails: String?
    
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
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        fetchData()
    //    }
    //
    private func fetchData() {
        fetchServiceCategories()
        if AuthManager.isLogged() {
            fetchAddresses()
            
        }
    }
    
    private func loadPoints() {
        
    }
    
    private func fetchAddresses() {
        ALoader.show()
        loadedAddresses = false
        HTTPClient.shared.request(method: .POST, path: .userAddressList) { (addressList: UserAddressListResponse?, error) in
            if let addressList = addressList {
                self.userAddressesViewModel = addressList.data.map({AddressViewModel(address: $0)})
                self.loadedAddresses = true
                UserManager.shared.loggedUser?.addresses = addressList.data
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
            alert.view.tintColor = Colors.ButtonGreen
            present(alert, animated: true, completion: nil)
            return
        }
        guard AuthManager.isLogged() else {
            let alert = UIAlertController(title: "Lo sentimos", message: "Debes registrarte para poder acceder a este servicio.", preferredStyle: .alert)
            let register = UIAlertAction(title: "Registrarme", style: .default) { (action) in
                let loginVC = UIStoryboard(name: "Start", bundle: nil).instantiateViewController(withIdentifier: "LandingViewControllerID") as! LandingViewController
                self.transition(to: loginVC, completion: nil)
            }
            alert.addAction(register)
            alert.view.tintColor = Colors.ButtonGreen
            let cancel = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard UserManager.shared.loggedUser?.addresses.count != 0 else {
            AlertManager.showNotice(in: self, title: "Necesitamos tu dirección", description: "Para poder solicitar un servicio, agrega tu primera dirección.", acceptButtonTitle: "Agregar Dirección") {
                let addressesStoryboard = UIStoryboard(name: "Addresses", bundle: nil)
                let addAddressVC =  addressesStoryboard.instantiateViewController(withIdentifier: "AddAddressTableViewControllerID") as! AddAddressTableViewController
                addAddressVC.delegate = self
                self.present(addAddressVC, animated: true, completion: nil)
            }
            return
        }
        
        showServiceCategoryPopup(serviceCategory: serviceCategory)
    }
    
    
    private func showServiceCategoryPopup(serviceCategory: CategoryViewModel) {
        guard let defaultAddress = UserManager.shared.loggedUser?.addresses.filter({$0.isDefault}).first else { return }
        
        var clientTypes: [ClientType] = []
        
        if serviceCategory.subCategories.isEmpty {
            clientTypes = serviceCategory.clientTypes
        } else {
            for subC in serviceCategory.subCategories {
                if subC.clientTypes.contains(where: { (ct) -> Bool in
                    ct.name == .mujer
                }) {
                    if !clientTypes.contains(where: { (ct) -> Bool in
                        return ct.name == .mujer
                    }) {
                        clientTypes.append(ClientType(id: 1, name: Name.mujer, displayName: Name.mujer))
                    }
                }
                if subC.clientTypes.contains(where: { (ct) -> Bool in
                    ct.name == .hombre
                }) {
                    if !clientTypes.contains(where: { (ct) -> Bool in
                        return ct.name == .hombre
                    }) {
                        clientTypes.append(ClientType(id: 2, name: Name.hombre, displayName: Name.hombre))
                    }
                }
                if subC.clientTypes.contains(where: { (ct) -> Bool in
                    ct.name == .niño
                }) {
                    if !clientTypes.contains(where: { (ct) -> Bool in
                        return ct.name == .niño
                    }) {
                        clientTypes.append(ClientType(id: 3, name: Name.niño, displayName: Name.niño))
                    }
                }
            }
        }
        
        
        let data = ServiceCategorySelectionData(address: AddressViewModel(address: defaultAddress).addressFormatted,
                                                addressId: defaultAddress.id,
                                                addressName: defaultAddress.name,
                                                clientName: UserManager.shared.clientName,
                                                clientType: nil,
                                                category: serviceCategory,
                                                availableClientTypes: clientTypes)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ScheduleService,
            let dvc = segue.destination as? ServiceSelectionViewController {
            dvc.category = selectedCategory
            dvc.clientName = selectedClientName
            dvc.addressId = selectedAddressId
            dvc.addressName = addressName
            dvc.addressDetails = addressDetails
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
    func didPressContinue(data: ServiceCategorySelectionData) {
        let selectedClientType = data.clientType
        let subCategoriesForSelectedClient = data.category.subCategories.filter { (cat) -> Bool in
            return cat.clientTypes.contains { (ct) -> Bool in
                return selectedClientType?.name == ct.name
            }
        }
        selectedCategory = data.category
        selectedClientName = data.clientName
        selectedAddressId = data.addressId
        addressName = data.addressName
        addressDetails = data.address
        selectedCategory?.subCategories = subCategoriesForSelectedClient
        removeBlackBackgroundView()
        performSegue(withIdentifier: Segues.ScheduleService, sender: self)
    }
    
    func didPressCancel() {
        removeBlackBackgroundView()
    }
    
}
