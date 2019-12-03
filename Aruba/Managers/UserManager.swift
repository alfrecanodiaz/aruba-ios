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
                     completion: @escaping (HTTPClientError?) -> Void)
    func getAddresses(completion: @escaping ([AAddress]?, Error?) -> Void)
    func deleteAddress(id: String, completion: @escaping (Error?) -> Void)
}

class UserManager: UserManagerProtocol {

    static let shared = UserManager()

    var loggedUser: User?

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
                     completion: @escaping (HTTPClientError?) -> Void) {
        let addressData: [String: Any] = ["name": name,
                                          "street1": street1,
                                          "street2": street2,
                                          "number": houseNumber,
                                          "references": references,
                                          "lat": lat,
                                          "lng": lng,
                                          "is_default": is_default]
        HTTPClient.shared.request(method: .POST, path: .userAddressAdd, data: addressData) { (response: DefaultResponse?, error) in
            completion(error)
        }
    }
}
