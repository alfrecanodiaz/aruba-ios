//
//  CartTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

struct CartData {
    let addressId: Int
    let addressName: String
    let addressDetail: String
    let categoryName: String
    let services: String
    let clientName: String
    let fullDate: String
    let servicesIds: [Int]
    let servicesTotals: [Service]
    var socialReason: String
    var ruc: String
    var total: Int
    var professional: Professional
    var hourStartAsSeconds: Int
    var date: String
    let categoryImageUrl: String
}

class CartTableViewController: UITableViewController {
    
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var fullDateLabel: UILabel!
    @IBOutlet weak var socialReasonTextField: ATextField!
    @IBOutlet weak var rucTextField: ATextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var changeAmountTextField: ATextField!
    @IBOutlet weak var paymentInfoLabel: UILabel!
    @IBOutlet weak var serviceIconImageView: ARoundImage!
    
    // Inject in prepare for segue
    var cartData: CartData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        addressNameLabel.text = cartData.addressName
        addressDetailLabel.text = cartData.addressDetail
        categoryNameLabel.text = cartData.categoryName
        servicesLabel.text = cartData.services
        clientNameLabel.text = cartData.professional.firstName + " " + cartData.professional.lastName
        fullDateLabel.text = cartData.fullDate
        socialReasonTextField.text = UserManager.shared.userTax.first?.socialReason
        rucTextField.text = UserManager.shared.userTax.first?.rucNumber
        segmentedControl.sendActions(for: .valueChanged)
        guard let url = URL(string: cartData.categoryImageUrl) else { return }
        serviceIconImageView.kf.setImage(with: url)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        tableView.scrollToRow(at: IndexPath(row: 1, section: 2), at: .top, animated: true)
        if sender.selectedSegmentIndex == 0 {
            changeAmountTextField.isHidden = true
            paymentInfoLabel.isHidden = false
            let transferDataString = NSMutableAttributedString()
            let boldFont =  AFont.with(size: 15, weight: .regular)
            let attr: [NSAttributedString.Key: Any] = [.font: boldFont, .foregroundColor: UIColor(hexRGB: "A9A9AA")!]
            transferDataString.append(NSAttributedString(string: "Anota estos datos para poder realizar la transferencia ", attributes: attr))
            transferDataString.append(NSAttributedString(string: "\nBanco: ", attributes: attr))
            transferDataString.append(NSAttributedString(string: "Visión Banco", attributes: attr))
            transferDataString.append(NSAttributedString(string: "\nCta. №: ", attributes: attr))
            transferDataString.append(NSAttributedString(string: "14525758", attributes: attr))
            transferDataString.append(NSAttributedString(string: "\nRUC: ", attributes: attr))
            transferDataString.append(NSAttributedString(string: "80109397-0", attributes: attr))
            transferDataString.append(NSAttributedString(string: "\nBeauty Smart S.A.", attributes: attr))
            paymentInfoLabel.attributedText = transferDataString
        } else if sender.selectedSegmentIndex == 1 {
            changeAmountTextField.isHidden = true
            paymentInfoLabel.isHidden = false
            paymentInfoLabel.text = "Al presionar continuar se procedera a solicitar la información de su tarjeta de credito."
        }
        
    }
    
    
}
