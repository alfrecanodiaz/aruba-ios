//
//  UserManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/13/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

protocol UserManagerProtocol {
    func saveAddress(name: String, lat: String, lng: String, completion: @escaping (AAddress?,Error?) -> Void)
    func getAddresses()
    func deleteAddress(id: String)
}

class UserManager: UserManagerProtocol {

    func getAddresses() {
        // TODO
    }

    func deleteAddress(id: String) {
        // TODO
    }

    func saveAddress(name: String, lat: String, lng: String, completion: @escaping (AAddress?, Error?) -> Void) {
        HTTPClient.shared.request(method: .POST, path: .userAddressAdd) { (address: AAddress?, error) in
            if let error = error {
                print("Error while trying to save an address: ", error.localizedDescription)
            } else {

            }
            completion(address, error)
        }
    }
}
