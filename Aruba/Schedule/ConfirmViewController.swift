//
//  ConfirmViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var serviceImageView: UIImageView! {
        didSet {
            serviceImageView.layer.cornerRadius = 30
            serviceImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressDetailsLabel: UILabel!
    var category: CategoryViewModel!
    
    var cartData: CartData!
    
    struct Segues {
        static let Cart = "showCart"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryNameLabel.text = "Estas en la categoria \(category.title.uppercased())"
        
        addressNameLabel.text = cartData.addressName.uppercased()
        addressDetailsLabel.text = cartData.addressDetail
        categoryLabel.text = cartData.categoryName
        servicesLabel.text = cartData.services
        clientNameLabel.text = cartData.professional.firstName + " " + cartData.professional.lastName
        dateTimeLabel.text = cartData.fullDate
        totalLabel.text = cartData.total.asGs()
        guard let categoryUrl = category.imageURL, let url = URL(string: categoryUrl) else {
            return
        }
        serviceImageView.hnk_setImageFromURL(url, placeholder: Constants.imagePlaceholder )
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Cart, let dvc = segue.destination as? CartViewController {
            dvc.cartData = cartData
            dvc.delegate = self
        }
    }
    
}

extension ConfirmViewController: CartDelegate {
    func didCreateAppointment(appointment: Appointment) {
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension Int {
    func asGs() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_PY")
        return formatter.string(from: NSNumber(value: self))
    }
}
