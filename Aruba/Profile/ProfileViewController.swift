//
//  ProfileViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/18/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import Lottie

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var saveButton: AButton!
    
    weak var profileTVC: ProfileTableViewController?
    
    var savingPhoneData = false
    var savingProfileData = false
    var savingTaxData = false
    
    
    enum Segues {
        static let Profile = "EmbededProfile"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAction(_ sender: AButton) {
        
        guard let profileTVC = profileTVC,
            let phoneNumber = profileTVC.phoneTextField.text,
            !phoneNumber.isEmpty,
            let firstName = profileTVC.firstNameTextField.text,
            !firstName.isEmpty,
            let lastName = profileTVC.lastNameTextField.text,
            !lastName.isEmpty
            else {
                AlertManager.showNotice(in: self, title: "Atención",
                                        description: "Debes completar todos los datos.")
                return
        }
        if profileTVC.isPhoneDirty() {
            savePhoneData()
        }
        
        if profileTVC.isProfileDirty() {
            saveProfileData()
        }
        
        if profileTVC.isTaxDataDirty() {
            saveTaxData()
        }
    }
    
    private func savePhoneData() {
        if UserManager.shared.devices.count == 0,
            let phoneNumber = profileTVC?.phoneTextField.text, !phoneNumber.isEmpty {
            ALoader.show()
            savingPhoneData = true
            UserManager.shared.saveDevice(phoneNumber: phoneNumber){ (device, error) in
                if let error = error {
                    AlertManager.showErrorNotice(in: self, error: error) {
                        self.savePhoneData()
                    }
                } else if let device = device {
                    self.savingPhoneData = false
                    self.profileTVC?.currentDevice = device
                    self.successHandler()
                }
            }
        } else {
            guard let profileTVC = profileTVC, let device = profileTVC.currentDevice,
                let phoneNumber = profileTVC.phoneTextField.text, !phoneNumber.isEmpty else { return }
            ALoader.show()
            savingPhoneData = true
            UserManager.shared.updateDevice(phoneNumber: phoneNumber,
                                            device: device) { (error) in
                                                if let error = error {
                                                    AlertManager.showErrorNotice(in: self, error: error) {
                                                        self.savePhoneData()
                                                    }
                                                } else {
                                                    self.savingPhoneData = false
                                                    profileTVC.currentDevice = Device(version: profileTVC.currentDevice?.version,
                                                                                      phoneNumber: phoneNumber,
                                                                                      pushToken: profileTVC.currentDevice?.pushToken,
                                                                                      os: profileTVC.currentDevice?.os,
                                                                                      model: profileTVC.currentDevice?.model,
                                                                                      id: profileTVC.currentDevice?.id ?? 0)
                                                    self.successHandler()
                                                }
            }
        }
        
    }
    
    private func saveProfileData() {
        
        guard let profileTVC = profileTVC,
            let firstName = profileTVC.firstNameTextField.text,
            !firstName.isEmpty else {
                self.profileTVC?.firstNameTextField.setError(ValidationError.missingField, animated: true)
                return
        }
        
        guard let lastName = profileTVC.lastNameTextField.text,
            !lastName.isEmpty else {
                self.profileTVC?.lastNameTextField.setError(ValidationError.missingField, animated: true)
                return
        }
        
        savingProfileData = true
        ALoader.show()

        UserManager.shared.updateProfile(firstName: firstName,
                                         lastName: lastName) { (error) in
                                            if let error = error {
                                                AlertManager.showErrorNotice(in: self, error: error) {
                                                    self.saveProfileData()
                                                }
                                            } else {
                                                self.savingProfileData = false
                                                UserManager.shared.loggedUser?.firstName = firstName
                                                UserManager.shared.loggedUser?.lastName = lastName
                                                self.successHandler()
                                            }
        }
    }
    
    enum ValidationError: Error {
        case missingField
        
        var localizedDescription: String {
            return "Debes completar este campo."
        }

    }
    
    private func saveTaxData() {
        guard let profileTVC = profileTVC,
            let ruc = profileTVC.rucTextField.text,
            !ruc.isEmpty else {
                self.profileTVC?.rucTextField.setError(ValidationError.missingField, animated: true)
                return
        }
        
        guard let socialReason = profileTVC.socialReasonTextField.text,
            !socialReason.isEmpty else {
                self.profileTVC?.socialReasonTextField.setError(ValidationError.missingField, animated: true)
                return
        }
        savingTaxData = true
        if let taxInfo = UserManager.shared.userTax.first {
            ALoader.show()
            UserManager.shared.updateTaxInfo(id: taxInfo.id, ruc: ruc, socialReason: socialReason) { (error) in
                if let error = error {
                    AlertManager.showErrorNotice(in: self, error: error) {
                        self.saveTaxData()
                    }
                } else {
                    self.savingTaxData = false
                    self.successHandler()
                }
                
            }
        } else {
            ALoader.show()
            UserManager.shared.saveTaxInfo(ruc: ruc, socialReason: socialReason) { (error) in
                if let error = error {
                    AlertManager.showErrorNotice(in: self, error: error) {
                        self.saveTaxData()
                    }
                } else {
                    self.savingTaxData = false
                    self.successHandler()
                }
                
            }
        }
        
    }
    
    private func successHandler() {
        if !savingProfileData && !savingTaxData && !savingPhoneData {
            ALoader.hide()
            showSuccess()
        }
    }
    
    private func showSuccess() {
        let lottie = AnimationView(name: "success")
        lottie.frame = self.view.bounds
        lottie.contentMode = .scaleAspectFit
        self.view.addSubview(lottie)
        lottie.play { (_) in
            lottie.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Profile,
            let destination = segue.destination as? ProfileTableViewController {
            profileTVC = destination
        }
    }
    
    
    
}
