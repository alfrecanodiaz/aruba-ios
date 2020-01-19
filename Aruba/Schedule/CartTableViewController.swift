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
    var socialReason: String
    var ruc: String
    var total: Int
    var professional: Professional
    var hourStartAsSeconds: Int
    var date: String
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
        socialReasonTextField.text = cartData.socialReason
        rucTextField.text = cartData.ruc
        segmentedControl.sendActions(for: .valueChanged)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        tableView.scrollToRow(at: IndexPath(row: 1, section: 2), at: .top, animated: true)
        if sender.selectedSegmentIndex == 0 {
            changeAmountTextField.isHidden = true
            paymentInfoLabel.isHidden = false
            let transferDataString = NSMutableAttributedString()
            let boldFont =  AFont.with(size: 15, weight: .bold)
            let regularFont = AFont.with(size: 15, weight: .regular)
            transferDataString.append(NSAttributedString(string: "Anota estos datos para poder realizar la transferencia ", attributes: [.font: boldFont]))
            transferDataString.append(NSAttributedString(string: "\nBanco: ", attributes: [.font: boldFont]))
            transferDataString.append(NSAttributedString(string: "Visión Banco", attributes: [.font: regularFont]))
            transferDataString.append(NSAttributedString(string: "\nCta. №: ", attributes: [.font: boldFont]))
            transferDataString.append(NSAttributedString(string: "1433 1724", attributes: [.font: regularFont]))
            transferDataString.append(NSAttributedString(string: "\nC.I. №: ", attributes: [.font: boldFont]))
            transferDataString.append(NSAttributedString(string: "3.399.394", attributes: [.font: regularFont]))
            transferDataString.append(NSAttributedString(string: "\nMaria Martha Cabello", attributes: [.font: regularFont]))
            paymentInfoLabel.attributedText = transferDataString
        } else if sender.selectedSegmentIndex == 1 {
            changeAmountTextField.isHidden = true
            paymentInfoLabel.isHidden = false
            paymentInfoLabel.text = "Al presionar continuar se procedera a solicitar la información de su tarjeta de credito."
        }
        
    }
    
    
}
