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
        guard let defaultAddress = UserManager.shared.loggedUser?.addresses.filter({$0.isDefault}).first else {
            return nil
        }
        return defaultAddress.id
    }
    
    var clientName: String {
        guard let loggedUser = loggedUser else { return "" }
        return loggedUser.firstName + " " + loggedUser.lastName
    }
    
    var currentPhoneNumber: String? {
        return nil
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
                    completion: @escaping (HTTPClientError?) -> Void) {
        
        var params: [String: Any] = [
            "os" : "iOS",
            "model": UIDevice.current.model,
            "version": UIDevice.current.systemVersion,
            "phone_number" : phoneNumber
        ]
        if let pushToken = self.pushToken {
            params["push_token"] = pushToken
        }
        
        HTTPClient.shared.request(method: .POST, path: .userRegisterDevice, data: params) { (response: UserRegisterDeviceResponse?, error) in
            completion(error)
        }
    }
    
    func updateDevice(phoneNumber: String,
                      device: Device,
                      completion: @escaping (HTTPClientError?) -> Void) {
        
        let params: [String: Any] = [
            "id" : device.id,
            "phone_number" : phoneNumber
        ]
        
        HTTPClient.shared.request(method: .POST, path: .userDeviceUpdate, data: params) { (response: UserRegisterDeviceResponse?, error) in
            completion(error)
        }
    }
    
    func listDevices(completion: @escaping ([Device]? , HTTPClientError?) -> Void) {
                
        HTTPClient.shared.request(method: .POST, path: .userDeviceList) { (response: UserDeviceListResponse?, error) in
            completion(response?.data, error)
        }
    }
    
    /// TAX
    
    func saveTaxInfo(ruc: String, socialReason: String, completion: @escaping (HTTPClientError?) -> Void ) {
        
    }
    
    
}
