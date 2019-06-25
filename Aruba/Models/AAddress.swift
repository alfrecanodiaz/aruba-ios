//
//  Address.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct AddressViewModel {

    private let address: AAddress

    var name: String {
        return address.nombre ?? ""
    }

    var street1: String {
        return address.calle1 
    }

    var street2: String {
        return address.calle2
    }

    var houseNumber: String {
        return address.numero
    }

    var reference: String {
        return address.referencias
    }

    var addressFormatted: String {
        return name + ": " + street1 + ", " + street2 + " " + houseNumber + "\n" + reference
    }

    init (address: AAddress) {
        self.address = address
    }
}
