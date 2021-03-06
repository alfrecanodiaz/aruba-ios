//
//  CartViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/16/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol CartDelegate: class {
    func didCreateAppointment(appointment: Appointment)
}
class CartViewController: BaseViewController {
    
    @IBOutlet weak var contitnueButton: AButton!
    var cartData: CartData!
    weak var delegate: CartDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    weak var cartTVC: CartTableViewController?
    
    struct Segues {
        static let Cart = "cartEmbeded"
        static let CardPayment = "showCardPayment"
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Cart, let dvc = segue.destination as? CartTableViewController {
            dvc.cartData = cartData
            cartTVC = dvc
        }
        
        if segue.identifier == Segues.CardPayment, let dvc = segue.destination as? CardPaymentViewController {
            dvc.cartData = cartData
            dvc.delegate = self
        }
    }
    
    private func storePhoneNumber() {
        AlertManager.showNotice(in: self,
                                title: "Atención",
                                description: "Necesitamos tu número teléfonico para asegurar que el profesional llegue a tu destino correctamente.",
                                textFieldPlaceholder: "Número de teléfono") { value in
                                    ALoader.show()
                                    UserManager.shared.saveDevice(phoneNumber: value) { device, error in
                                        ALoader.hide()
                                        if let error = error {
                                            AlertManager.showErrorNotice(in: self, error: error) {
                                                self.storePhoneNumber()
                                            }
                                        } else {
                                            self.continueAction(self.contitnueButton)
                                        }
                                    }
        }
    }
    
    @IBAction func continueAction(_ sender: AButton) {
        
        if UserManager.shared.currentPhoneNumber == nil {
            storePhoneNumber()
            return
        }
        
        if cartTVC?.segmentedControl.selectedSegmentIndex == 0 {
            finishAppointment(paymentType: 3, clientAmount: nil)
        }
        if cartTVC?.segmentedControl.selectedSegmentIndex == 1 {
            performSegue(withIdentifier: Segues.CardPayment, sender: nil)
        }
    }
    
    private func finishAppointment(paymentType: Int, clientAmount: String?) {
        ALoader.showCalendarLoader()
        var params: [String: Any] = [
            "professional_id":cartData.professional.id,
            "address_id": cartData.addressId,
            "hour_start": cartData.hourStartAsSeconds,
            "date": cartData.date,
            "services_id": cartData.servicesIds,
            "payment_type": paymentType
        ]
        if let clientAmount = clientAmount {
            params["client_amount"] = clientAmount
        }
        HTTPClient.shared.request(method: .POST, path: .createAppointment, data: params) { (response: CreateAppointmentResponse?, error) in
            ALoader.hideCalendarLoader()
            if let _ = response {
                self.showSuccessPopup()
            } else if let error = error {
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
            }
        }
    }
    
    private func showSuccessPopup() {
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "SuccessPopoverTableViewControllerID") as! SuccessPopoverTableViewController
        
        popup.modalPresentationStyle = .popover
        popup.delegate = self
        let popover = popup.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = view
        popover?.sourceRect = view.bounds
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popup.clientName = cartData.clientName
        addBlackBackgroundView()
        present(popup, animated: true, completion: nil)
    }
}

extension CartViewController: CardPaymentDelegate {
    func successCardPayment() {
        self.showSuccessPopup()
    }
    
    func canceledCardPayment() {
        
    }
}

extension CartViewController: SuccessPopoverDelegate {
    func didPressBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
