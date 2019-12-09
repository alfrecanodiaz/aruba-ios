//
//  ServiceCategorySelectionPopupTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/7/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol ServiceCategorySelectionDelegate: class {
    func didPressContinue(data: ServiceCategorySelectionData)
    func didPressCancel()
}


struct ServiceCategorySelectionData {
    var address: String
    var addressId: Int
    var clientName: String
    var clientType: ClientType?
    var category: CategoryViewModel
    let availableClientTypes: [ClientType]
    
}

class ServiceCategorySelectionPopupTableViewController: APopoverTableViewController {
    
    @IBOutlet weak var serviceCategoryTitleLabel: UILabel!
    @IBOutlet weak var closeView: UIView!
    
    @IBOutlet weak var addressTextField: ATextField! {
        didSet {
            addressTextField.delegate = self
        }
    }
    @IBOutlet weak var clientNameTextField: ATextField!
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var manImageView: UIImageView!
    @IBOutlet weak var womanImageView: UIImageView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var manView: UIView!
    @IBOutlet weak var womanView: UIView!
    
    weak var delegate: ServiceCategorySelectionDelegate?
    
    var data: ServiceCategorySelectionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        addressTextField.text = data?.address
        clientNameTextField.text = data?.clientName
        serviceCategoryTitleLabel.text = data?.category.title.uppercased()
        guard let data = data else { return }
        if !data.availableClientTypes.contains(where: { (ct) -> Bool in
            return ct.name == .mujer
        }) {
            womanView.isHidden = true
        }
        if !data.availableClientTypes.contains(where: { (ct) -> Bool in
            return ct.name == .hombre
        }) {
            manView.isHidden = true
        }
        if !data.availableClientTypes.contains(where: { (ct) -> Bool in
            return ct.name == .niño
        }) {
            childView.isHidden = true
        }
        setClientType()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        delegate?.didPressCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func womanAction(_ sender: UIButton) {
        data?.clientType = ClientType(id: 1, name: Name.mujer, displayName: Name.mujer)
        setClientType()
    }
    @IBAction func manAction(_ sender: UIButton) {
        data?.clientType = ClientType(id: 2, name: Name.hombre, displayName: Name.hombre)
        setClientType()
    }
    @IBAction func kidAction(_ sender: UIButton) {
        data?.clientType = ClientType(id: 3, name: Name.niño, displayName: Name.niño)
        setClientType()
    }
    
    private func setClientType() {
        view.endEditing(true)
        womanImageView.image = data?.clientType?.name == .mujer ? #imageLiteral(resourceName: "selection_women") : #imageLiteral(resourceName: "icon_profile_woman_inactive")
        manImageView.image = data?.clientType?.name == .hombre ? #imageLiteral(resourceName: "iconos_usuario (arrastrado) 42") : #imageLiteral(resourceName: "icon_profile_man_inactive")
        childImageView.image = data?.clientType?.name == .niño ? #imageLiteral(resourceName: "icon_profile_kid_active") : #imageLiteral(resourceName: "children")
    }
    
    @IBAction func continueAction(_ sender: AButton) {
        if data?.clientType == nil {
            AlertManager.showNotice(in: self, title: "Atención", description: "Elige el tipo de cliente para el servicio.")
            return
        }
        if clientNameTextField.text == nil ||
            clientNameTextField.text == ""  {
            AlertManager.showNotice(in: self, title: "Atención", description: "El nombre del cliente no puede quedar en blanco.")
            return
        }
        guard let data = data else {
            return
        }
        dismiss(animated: true) {
            self.delegate?.didPressContinue(data: data)
        }
    }
    
    
}


extension ServiceCategorySelectionPopupTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addressTextField {
            let alert = UIAlertController(title: "Seleccióna tu dirección", message: nil, preferredStyle: .alert)
            let addresses = UserManager.shared.loggedUser?.addresses ?? []
            
            for addr in addresses {
                alert.addAction(UIAlertAction(title: addr.name + ": \(addr.street1)", style: .default, handler: { (_) in
                    self.addressTextField.text = AddressViewModel(address: addr).addressFormatted
                    self.data?.address = self.addressTextField.text ?? ""
                    self.data?.addressId = addr.id
                }))
            }
            alert.addAction(UIAlertAction(title: "Atras", style: .cancel, handler: nil))
            alert.view.tintColor = Colors.ButtonHighlightedGreen
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}
