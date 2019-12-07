//
//  UserManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/13/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

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
    func getAddresses(completion: @escaping ([AAddress]?, Error?) -> Void)
    func deleteAddress(id: String, completion: @escaping (Error?) -> Void)
}

class UserManager: UserManagerProtocol {

    static let shared = UserManager()

    var loggedUser: User?
    
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
    

    func deleteAddress(id: String, completion: @escaping (Error?) -> Void) {
        
    }

    func getAddresses(completion: @escaping ([AAddress]?, Error?) -> Void) {
//        HTTPClient.shared.request(method: .POST, path: .userAddressList) { (response: UserAddressListResponse?, error) in
//            completion(response?.items, error)
//        }
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
}
