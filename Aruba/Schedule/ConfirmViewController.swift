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
    
    @IBOutlet weak var serviceImageView: ARoundImage!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressDetailsLabel: UILabel!
    @IBOutlet weak var bottomTotalContainerView: UIView!

    var cartData: CartData!
    
    struct Segues {
        static let Cart = "showCart"
    }
    
    lazy var bottomTotalView: BottomTotalView = {
        BottomTotalView.build(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomTotalView()
        categoryNameLabel.text = "Estas en la categoria \(cartData.categoryName.uppercased())"
        
        addressNameLabel.text = cartData.addressName.uppercased()
        addressDetailsLabel.text = cartData.addressDetail
        categoryLabel.text = cartData.categoryName
        servicesLabel.text = cartData.services
        clientNameLabel.text = cartData.professional.firstName + " " + cartData.professional.lastName
        dateTimeLabel.text = cartData.fullDate
        guard let url = URL(string: cartData.categoryImageUrl) else {
            return
        }
        serviceImageView.kf.setImage(with: url, placeholder: GlobalConstants.imagePlaceholder )
    }
    
    private func setupBottomTotalView() {
        bottomTotalContainerView.addSubview(bottomTotalView)
        bottomTotalView.constraintToSuperView()
        DispatchQueue.main.async {
            self.bottomTotalView.continueButton.setEnabled(true, animated: false)
        }
        bottomTotalView.totalLabel.text = "Total:   \(cartData.total.asGs() ?? "")"
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

extension ConfirmViewController: BottomTotalViewDelegate {
    func didSelectContinue(view: BottomTotalView) {
        performSegue(withIdentifier: Segues.Cart, sender: self)
    }
}
