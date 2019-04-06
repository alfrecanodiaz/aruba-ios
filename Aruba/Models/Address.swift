//
//  Address.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct Address: Codable {
    let name: String
    let lat: Double
    let lng: Double
    let street1: String
    let street2: String
    let houseNumber: String
    let reference: String
    
    init () {
        name = "Casa"
        lat = 0
        lng = 0
        street1 = "Street 1"
        street2 = "Street 2"
        houseNumber = "324"
        reference = "Al lado del Estacionamiento"
    }
}
