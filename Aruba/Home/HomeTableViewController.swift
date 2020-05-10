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
    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    struct Cells {
        static let Category = "homeCategoryCell"
    }
    
    struct Segues {
        static let ScheduleService = "scheduleServiceSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        sideMenuButton.isEnabled = AuthManager.isLogged()
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
    
    @IBAction func showSideMenuAction(_ sender: Any) {
        if AuthManager.isLogged() {
            performSegue(withIdentifier: "presentSideMenuSegue", sender: self)
        }
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
        let hasSubcategoriesEnabled = serviceCategory.subCategories.reduce(false) { partial, next in
            partial || next.enabled
        }
        
        guard !needsShowCovidAlert() else {
            showCovidAlert()
            return
        }
        
        guard serviceCategory.enabled else {
            let alert = UIAlertController(title: "Lo sentimos", message: serviceCategory.inactiveText ?? "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.view.tintColor = Colors.AlertTintColor
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard hasSubcategoriesEnabled else {
            let alert = UIAlertController(title: "Lo sentimos", message: "No hay subcategorias disponibles para este servicio.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Aceptar", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.view.tintColor = Colors.AlertTintColor
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
            alert.view.tintColor = Colors.AlertTintColor
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
    
    private func needsShowCovidAlert() -> Bool {
        let needsShow = UserDefaults.standard.value(forKey: CovidAlertController.Constants.covidAlert) as? Bool ?? true
        return needsShow
    }
    
    private func showCovidAlert() {
        let alert = CovidAlertController()
        alert.modalPresentationStyle = .popover
        let popover = alert.popoverPresentationController
        popover?.delegate = self
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(alert, animated: true, completion: nil)
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


class CovidAlertController: UIViewController {
    
    let check1 = ACheckBoxButton()
    let check2 = ACheckBoxButton()
    let check3 = ACheckBoxButton()
    
    enum Constants {
        static let covidAlert = "CovidAlertKey"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.backgroundColor = .white
        
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            bottomConstraint
        ])
        
        let top = UILabel()
        top.text = "Medidas de Seguridad"
        top.textColor = Colors.ButtonGreen
        top.textAlignment = .center
        stackView.addArrangedSubview(top)
        
        let title = UILabel()
        title.text = "Por medidas de seguridad y prevencion declaro bajo fe de juramento que ni yo y ninguna de las personas que solicitan los servicios de Aruba:"
        title.textColor = .lightGray
        title.numberOfLines = 0
        title.font = AFont.with(size: 13, weight: .regular)
        stackView.addArrangedSubview(title)
        
        check1.setTitle("Tengo/tienen ningún síntoma relacionado al Covid-19 (fiebre, dolor de cabeza, tos, estornudo, secreción nasal, fatiga, dolor de garganta, dificultad para respirar)", for: .normal)
        check1.addTarget(self, action: #selector(check1Tapped), for: .touchUpInside)
        stackView.addArrangedSubview(check1)
        
        check2.setTitle("Estuve/estuvieron en contacto con personas que volvieron de paises del exterior durante el periodo de cuarentena.", for: .normal)
        stackView.addArrangedSubview(check2)
        check2.addTarget(self, action: #selector(check2Tapped), for: .touchUpInside)
        
        check3.setTitle("Estuve/estuvieron contacto con personas de forma directa con personas que dieron positivcas al Covid-19.", for: .normal)
        stackView.addArrangedSubview(check3)
        check3.addTarget(self, action: #selector(check3Tapped), for: .touchUpInside)

        
        let accept = AButton()
        accept.setTitle("EMPEZAR A RESERVAR", for: .normal)
        stackView.addArrangedSubview(accept)
        stackView.setCustomSpacing(20, after: check3)
        accept.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)
    }
    
    @objc func check1Tapped() {
        check1.isSelected.toggle()
    }
    
    @objc func check2Tapped() {
        check2.isSelected.toggle()
    }
    
    @objc func check3Tapped() {
        check3.isSelected.toggle()
    }
    
    @objc func didTapAccept() {
        guard check1.isSelected && check2.isSelected && check3.isSelected else {
            return
        }
        UserDefaults.standard.setValue(false, forKey: Constants.covidAlert)
        self.dismiss(animated: true, completion: nil)
    }
    
}

class ACheckBoxButton: UIButton {
    
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        configureButton(self)
    }
    
    private func configureButton(_ button: UIButton) {
           button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = AFont.with(size: 12, weight: .regular)
            button.setImage(#imageLiteral(resourceName: "checkbox-empty"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "checkbox-checked"), for: .selected)
            button.titleLabel?.numberOfLines = 0
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
       }

    override var intrinsicContentSize: CGSize {
        return titleLabel?.intrinsicContentSize ?? CGSize(width: 100, height: 100)
    }
    
    override func layoutSubviews() {
        titleLabel?.preferredMaxLayoutWidth = self.titleLabel?.frame.size.width ?? 0
        super.layoutSubviews()
    }
}
