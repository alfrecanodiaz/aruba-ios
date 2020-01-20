//
//  UserManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/13/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

protocol UserManagerProtocol {
    func saveAddress(name: String,
                     street1: String,
                     street2: String,
                     houseNumber: String,
                     references: String,
                     lat: Double,
                     lng: Double,
                     is_default: Bool,
                     completion: @escaping (AAddress?, HTTPClientError?) -> Void)
    func getAddresses(completion: @escaping ([AAddress]?, HTTPClientError?) -> Void)
    func deleteAddress(id: Int, completion: @escaping (HTTPClientError?) -> Void)
    
    var loggedUser: User? { get }
}

class UserManager: UserManagerProtocol {
    
    static let shared = UserManager()
    
    var loggedUser: User?
    
    var pushToken: String?
    
    var defaultAddressString: String {
        guard let defaultAddress = UserManager.shared.loggedUser?.addresses.filter({$0.isDefault}).first else {
            return "No existen direcciónes"
        }
        let vm = AddressViewModel(address: defaultAddress)
        return vm.addressFormatted
    }
    
    var defaultAddressId: Int? {
        UserManager.shared.loggedUser?.addresses.filter({$0.isDefault}).first?.id
    }
    
    var clientName: String {
        guard let loggedUser = loggedUser else { return "" }
        return loggedUser.firstName + " " + loggedUser.lastName
    }
    
    var currentPhoneNumber: String? {
        return devices.first(where: {$0.phoneNumber != nil })?.phoneNumber
    }
    
    var devices: [Device] = []
    var userTax: [UserTax] = []
    
    var currentDevice: Device? {
        if devices.count == 0 {
            return nil
        }
        if let deviceWithPhone = devices.first(where: { (device) -> Bool in
            return device.phoneNumber != nil
        }) {
            return deviceWithPhone
        }
        return devices.first
    }
    
    func updateProfile(firstName: String, lastName: String, completion: @escaping (HTTPClientError?) -> Void) {
        let params: [String: Any] = ["first_name": firstName, "last_name": lastName]
        HTTPClient.shared.request(method: .POST, path: .userModify, data: params) { (response: DefaultResponseAsString?, error) in
            completion(error)
        }
    }
    
    func deleteAddress(id: Int, completion: @escaping (HTTPClientError?) -> Void) {
        let params: [String: Any] = ["id": id]
        HTTPClient.shared.request(method: .POST, path: .userAddressRemove, data: params) { (response: DefaultResponseAsString?, error) in
            if error == nil {
                UserManager.shared.loggedUser?.addresses.removeAll(where: {$0.id == id})
            }
            completion(error)
        }
    }
    
    func getAddresses(completion: @escaping ([AAddress]?, HTTPClientError?) -> Void) {
        HTTPClient.shared.request(method: .POST, path: .userAddressList) { (response: UserAddressListResponse?, error) in
            if let addresses = response?.data {
                UserManager.shared.loggedUser?.addresses = addresses
            }
            completion(response?.data, error)
        }
    }
    
    func saveAddress(name: String,
                     street1: String,
                     street2: String,
                     houseNumber: String,
                     references: String,
                     lat: Double,
                     lng: Double,
                     is_default: Bool,
                     completion: @escaping (AAddress?, HTTPClientError?) -> Void) {
        let addressData: [String: Any] = ["name": name,
                                          "street1": street1,
                                          "street2": street2,
                                          "number": houseNumber,
                                          "references": references,
                                          "lat": lat,
                                          "lng": lng,
                                          "is_default": is_default]
        HTTPClient.shared.request(method: .POST, path: .userAddressAdd, data: addressData) { (response: UserAddressStoreSuccessResponse?, error) in
            if let address = response?.data {
                guard let loggedUser = UserManager.shared.loggedUser else {
                    return
                }
                if loggedUser.addresses.count != 0, let index = loggedUser.addresses.firstIndex(where: {$0.isDefault}) {
                    UserManager.shared.loggedUser?.addresses[index].setNonDefault()
                    UserManager.shared.loggedUser?.addresses.append(address)
                } else {
                    UserManager.shared.loggedUser?.addresses = [address]
                }
            }
            completion(response?.data, error)
        }
    }
    
    func updateAddress(name: String,
                       street1: String,
                       street2: String,
                       houseNumber: String,
                       references: String,
                       lat: Double,
                       lng: Double,
                       is_default: Bool,
                       id: Int,
                       completion: @escaping (AAddress?, HTTPClientError?) -> Void) {
        let addressData: [String: Any] = ["name": name,
                                          "street1": street1,
                                          "street2": street2,
                                          "number": houseNumber,
                                          "references": references,
                                          "lat": lat,
                                          "lng": lng,
                                          "is_default": is_default,
                                          "id": id]
        HTTPClient.shared.request(method: .POST, path: .userAddressUpdate, data: addressData) { (response: UserAddressStoreSuccessResponse?, error) in
            completion(response?.data, error)
        }
    }
    
    func setAddressIsDefault(
        is_default: Bool,
        id: Int,
        completion: @escaping (AAddress?, HTTPClientError?) -> Void) {
        let addressData: [String: Any] = [
            "is_default": is_default,
            "id": id
        ]
        HTTPClient.shared.request(method: .POST, path: .userAddressUpdate, data: addressData) { (response: UserAddressStoreSuccessResponse?, error) in
            completion(response?.data, error)
        }
    }
    
    /// Devices
    
    func saveDevice(phoneNumber: String,
                    completion: @escaping (Device?, HTTPClientError?) -> Void) {
        
        var params: [String: Any] = [
            "os" : "iOS",
            "model": modelIdentifier(),
            "version": UIDevice.current.systemVersion,
            "phone_number" : phoneNumber
        ]
        if let pushToken = self.pushToken {
            params["push_token"] = pushToken
        }
        
        HTTPClient.shared.request(method: .POST, path: .userRegisterDevice, data: params) { (response: UserRegisterDeviceResponse?, error) in
            if let device = response?.data {
                UserManager.shared.devices = [device]
            }
            completion(response?.data, error)
        }
    }
    
    func updateDevice(phoneNumber: String,
                      device: Device,
                      completion: @escaping (HTTPClientError?) -> Void) {
        
        let params: [String: Any] = [
            "os" : "iOS",
            "model": modelIdentifier(),
            "version": UIDevice.current.systemVersion,
            "id" : device.id,
            "phone_number" : phoneNumber
        ]
        
        HTTPClient.shared.request(method: .POST, path: .userDeviceUpdate, data: params) { (response: UserRegisterDeviceResponse?, error) in
            completion(error)
        }
    }
    
    func listDevices(completion: @escaping ([Device]? , HTTPClientError?) -> Void) {
        
        HTTPClient.shared.request(method: .POST, path: .userDeviceList) { (response: UserDeviceListResponse?, error) in
            if let devices = response?.data {
                UserManager.shared.devices = devices
            }
            completion(response?.data, error)
        }
    }
    
    /// TAX
    
    func saveTaxInfo(ruc: String, socialReason: String, completion: @escaping (HTTPClientError?) -> Void ) {
        let params: [String: Any] = ["ruc_number": ruc,
                                     "social_reason": socialReason]
        HTTPClient.shared.request(method: .POST, path: .userTaxCreate, data: params) { (response: UserRegisterNewTaxResponse?, error) in
            if let tax = response?.data {
                UserManager.shared.userTax = [tax]
            }
            completion(error)
        }
        
    }
    
    func updateTaxInfo(id: Int, ruc: String, socialReason: String, completion: @escaping (HTTPClientError?) -> Void ) {
        let params: [String: Any] = ["id": id,
                                     "ruc_number": ruc,
                                     "social_reason": socialReason]
        HTTPClient.shared.request(method: .POST, path: .userTaxUpdate, data: params) { (response: UserRegisterNewTaxResponse?, error) in
            if let tax = response?.data {
                UserManager.shared.userTax = [tax]
            }
            completion(error)
        }
        
    }
    
    func getTaxInfo(completion: @escaping (HTTPClientError?) -> Void ) {
        HTTPClient.shared.request(method: .POST, path: .userTaxList) { (response: UserTaxInfoListResponse?, error) in
            if let tax = response?.data.first {
                UserManager.shared.userTax = [tax]
            }
            completion(error)
        }
        
    }
    
    private func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    
}

