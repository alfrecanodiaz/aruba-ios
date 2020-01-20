//
//  ProfileTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var profileImageView: ARoundImage!
    @IBOutlet weak var firstNameTextField: ATextField!
    @IBOutlet weak var lastNameTextField: ATextField!
    @IBOutlet weak var emailTextField: ATextField! {
        didSet {
            emailTextField.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var phoneTextField: ATextField! {
        didSet {
            phoneTextField.keyboardType = .phonePad
        }
    }
    @IBOutlet weak var socialReasonTextField: ATextField!
    @IBOutlet weak var rucTextField: ATextField!
    
    
    let userManager: UserManagerProtocol = UserManager()
    
    var addressesTVC: AddressesTableViewController?
    
    var currentDevice: Device?
    
    enum Segues {
        static let ShowAddress = "ShowAddressSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAddresses()
        loadTaxInfo()
        loadDevices()
        setupView()
    }
    
    private func setupView() {
        guard let user = UserManager.shared.loggedUser else { return }
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        emailTextField.text = user.email
        socialReasonTextField.text = UserManager.shared.userTax.first?.socialReason
        rucTextField.text = UserManager.shared.userTax.first?.rucNumber
        greetingLabel.text = "¡Hola \(user.firstName)!"
        guard let url = URL(string: user.avatarURL) else { return }
        profileImageView.hnk_setImageFromURL(url, placeholder: Constants.userPlaceholder)
    }
    
    private func loadDevices() {
        UserManager.shared.listDevices(completion: { (devices, error) in
            if let device = UserManager.shared.currentDevice {
                self.currentDevice = device
                self.phoneTextField.text = device.phoneNumber
            } else if let error = error {
                print(error.message)
            }
        })
    }
    
    private func loadAddresses() {
        UserManager.shared.getAddresses { [weak self] (addresses, error) in
            if let addresses = addresses {
                self?.addressesTVC?.addresses = addresses.map({ AddressViewModel(address: $0)})
                    .sorted(by: { (addr1, addr2) -> Bool in
                        return addr1.isDefault
                    })
                self?.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            } else {
                
            }
            
        }
    }
    
    private func loadTaxInfo() {
        UserManager.shared.getTaxInfo { error in
                    if error == nil {
                self.socialReasonTextField.text = UserManager.shared.userTax.first?.socialReason
                self.rucTextField.text = UserManager.shared.userTax.first?.rucNumber
            }

        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "add_button_round"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.contentMode = .scaleAspectFit
        let titleLabel = UILabel()
        titleLabel.font = AFont.with(size: 16, weight: .regular)
        titleLabel.text = "Direcciónes"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIView()
        containerView.addSubview(titleLabel)
        containerView.addSubview(button)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                            constant: 10)
        ])
        button.addTarget(self, action: #selector(addNewAddressAction(sender:)), for: .touchUpInside)
        return containerView
    }
    
    @objc func addNewAddressAction(sender: UIButton) {
        self.performSegue(withIdentifier: Segues.ShowAddress, sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 180
            }
            return 80
        }
        guard let count = self.addressesTVC?.addresses.count else { return 0 }
        return CGFloat(count)*GenericDataCellTableViewCell.Constants.height
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embededAddressesSegue",
            let destination = segue.destination as? AddressesTableViewController {
            addressesTVC = destination
        }
        
        if segue.identifier == Segues.ShowAddress,
            let destination = segue.destination as? AddAddressTableViewController {
            destination.delegate = self
        }
    }
    
    func isPhoneDirty() -> Bool {
        guard let currentDevicePhone = currentDevice else { return true }
        if currentDevice?.phoneNumber == nil {
            return true
        }
        if phoneTextField.text != currentDevicePhone.phoneNumber {
            return true
        }
        return false
    }
    
    func isProfileDirty() -> Bool {
        guard let user = UserManager.shared.loggedUser else { return false }
        
        if firstNameTextField.text != user.firstName ||
            lastNameTextField.text != user.lastName {
            return true
        }
        return false
    }
    
    func isTaxDataDirty() -> Bool {
        guard let taxInfo = UserManager.shared.userTax.first else { return true }
        
        if rucTextField.text != taxInfo.rucNumber ||
            socialReasonTextField.text != taxInfo.socialReason {
            return true
        }
        return false
    }
    
}

extension ProfileTableViewController: AddAddressDelegate {
    
    func didSaveAddress(address: AAddress) {
        self.addressesTVC?.addresses.append(AddressViewModel(address: address))
        self.tableView.reloadData()
    }
    
}
