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
                     completion: @escaping (AddressViewModel?, Error?) -> Void)
    func getAddresses(completion: @escaping ([AAddress]?, Error?) -> Void)
    func deleteAddress(id: String, completion: @escaping (Error?) -> Void)
}

class UserManager: UserManagerProtocol {

    static let shared = UserManager()

    var loggedUser: UserLoginResponse?

    func deleteAddress(id: String, completion: @escaping (Error?) -> Void) {
        
    }

    func getAddresses(completion: @escaping ([AAddress]?, Error?) -> Void) {
        HTTPClient.shared.request(method: .POST, path: .userAddressList) { (response: UserAddressListResponse?, error) in
            completion(response?.items, error)
        }
    }

    func saveAddress(name: String,
                     street1: String,
                     street2: String,
                     houseNumber: String,
                     references: String,
                     lat: Double,
                     lng: Double,
                     completion: @escaping (AddressViewModel?, Error?) -> Void) {
        let addressData: [String: Any] = ["nombre": name,
                                          "calle1": street1,
                                          "calle2": street2,
                                          "numero": houseNumber,
                                          "referencias": references,
                                          "latitud": lat,
                                          "longitud": lng]
        let params = ["datosUbicacion": addressData]
        HTTPClient.shared.request(method: .POST, path: .userAddressAdd, data: params) { (response: DefaultResponse?, error) in
            if let error = error {
                print("Error while trying to save an address: ", error.localizedDescription)
            } else {

            }
//            let address = AAddress(name: name,
//                                   lat: lat,
//                                   lng: lng,
//                                   street1: street1,
//                                   street2: street2,
//                                   houseNumber: houseNumber,
//                                   reference: references)
//            let addressVM = AddressViewModel(address: address)
            completion(nil, error)
        }
    }
}
