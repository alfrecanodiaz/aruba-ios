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
    
    var cartData: CartData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressNameLabel.text = cartData.addressName
        addressDetailLabel.text = cartData.addressDetail
        categoryNameLabel.text = cartData.categoryName
        servicesLabel.text = cartData.services
        clientNameLabel.text = cartData.professional.firstName + " " + cartData.professional.lastName
        fullDateLabel.text = cartData.fullDate
        socialReasonTextField.text = cartData.socialReason
        rucTextField.text = cartData.ruc
    }
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
    }
    
    
}
