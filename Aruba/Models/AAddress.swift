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
        return address.name
    }

    var street1: String {
        return address.street1
    }

    var street2: String {
        return address.street2
    }

    var houseNumber: String {
        return address.number
    }

    var reference: String {
        return address.references
    }

    var addressFormatted: String {
        return name + ": " + street1 + ", " + street2 + " " + houseNumber + "\n" + reference
    }

    init (address: AAddress) {
        self.address = address
    }
    
}
