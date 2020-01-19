//
//  AddressesTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/18/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

class AddressesTableViewController: UITableViewController {
    
    enum Cells {
        static let GenericData = "GenericDataCellTableViewCell"
    }
    
    var addresses: [AddressViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Cells.GenericData, bundle: nil), forCellReuseIdentifier: Cells.GenericData)
        tableView.tableFooterView = UIView()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addresses.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.GenericData,
                                                       for: indexPath) as? GenericDataCellTableViewCell else { return UITableViewCell() }
        cell.viewModel = GenericDataCellViewModel(address: addresses[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        if !address.isDefault {
            AlertManager.showNotice(in: self, title: "Cambiar dirección por defecto", description: "Quieres que \(address.name) sea tu dirección por defecto?", acceptButtonTitle: "Si, quiero.") {
                self.updateDefaultAddress(address: address, index: indexPath.row)
            }
            
        }
    }
    
    private func updateDefaultAddress(address: AddressViewModel, index: Int) {
        ALoader.show()
        UserManager.shared.setAddressIsDefault(is_default: true, id: address.id) { (address, error) in
            ALoader.hide()
            if let error = error {
                AlertManager.showErrorNotice(in: self, error: error)
            } else {
                self.loadAddresses()
            }
        }
    }
    
    private func loadAddresses() {
        ALoader.show()
        UserManager.shared.getAddresses { [weak self] (addresses, error) in
            ALoader.hide()
            guard let self = self else { return }
            if let addresses = addresses {
                self.addresses = addresses.map({ AddressViewModel(address: $0)})
                    .sorted(by: { (addr1, addr2) -> Bool in
                        return addr1.isDefault
                    })
                self.tableView.reloadData()
            } else if let error = error {
                AlertManager.showErrorNotice(in: self, error: error)
            }
        }
    }
    
}

extension AddressesTableViewController: GenericDataCellTableViewCellProtocol {
    func didSelectDelete(for index: Int) {
        let address = addresses[index]
        if address.isDefault {
            AlertManager.showNotice(in: self, title: "Atención", description: "No puedes borrar tu dirección por defecto")
            return
        }
        
        AlertManager.showNotice(in: self,
                                title: "Borrar Dirección",
                                description: "¿Estas seguro que quieres borrar la dirección \(addresses[index].name)?",
        acceptButtonTitle: "Borrar") {
            ALoader.show()
            UserManager.shared.deleteAddress(id: self.addresses[index].id) { (error) in
                ALoader.hide()
                guard let error = error else {
                    self.addresses.remove(at: index)
                    return
                }
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.localizedDescription)
            }
        }
    }
}
