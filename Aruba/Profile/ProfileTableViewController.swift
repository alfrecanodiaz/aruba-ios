//
//  ProfileTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    struct Cells {
        static let Header = "profileHeaderCell"
        static let GenericData = "GenericDataCellTableViewCell"
        static let AddNew = "AddNewCell"
    }

    var addresses: [AddressViewModel] = []
    var tax: Tax = Tax()

    let headerHeight: CGFloat = 80
    let userManager: UserManagerProtocol = UserManager()
    struct Segues {
        static let AddAddress = "ShowAddAddressSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadAddresses()
    }

    func loadAddresses() {
        userManager.getAddresses { [weak self] (addresses, error) in
            if let addresses = addresses {
                self?.addresses = addresses.map({ AddressViewModel(address: $0)})
                self?.tableView.reloadData()
            } else {

            }

        }
    }

    func setupView() {
        tableView.register(UINib(nibName: Cells.GenericData, bundle: nil), forCellReuseIdentifier: Cells.GenericData)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        if section == 1 {
            return addresses.count + 1
        }
        if section == 2 {
            return 2
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Header, for: indexPath) as? ProfileHeaderTableViewCell else { return UITableViewCell() }
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == addresses.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.AddNew, for: indexPath)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.GenericData, for: indexPath) as? GenericDataCellTableViewCell else { return UITableViewCell() }
                cell.viewModel = GenericDataCellViewModel(address: addresses[indexPath.row])
                cell.index = indexPath.row
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.GenericData, for: indexPath) as? GenericDataCellTableViewCell else { return UITableViewCell() }
            if indexPath.row == 0 {
                cell.viewModel = GenericDataCellViewModel(title: "NOMBRE: ", content: tax.socialReason)
            } else {
                cell.viewModel = GenericDataCellViewModel(title: "RUC: ", content: tax.socialReason)
            }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerViewForSection(section: section)
    }

    func headerViewForSection(section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight))
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: headerHeight/2).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: headerHeight/2).isActive = true

        let lbl = UILabel()
        if section == 1 {
            lbl.text = "DIRECCIÓNES"
            imgView.image = UIImage(named: "pin_direccion")

        } else {
            lbl.text = "FACTURA"
            imgView.image = UIImage(named: "factura")

        }
        view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8).isActive = true
        lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lbl.font = AFont.with(size: 14, weight: .bold)
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return headerHeight
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.bounds.height*0.3
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == addresses.count { // add new address
                self.performSegue(withIdentifier: Segues.AddAddress, sender: self)
            }
        }
    }

}
