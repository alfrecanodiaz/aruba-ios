//
//  UserRegisterNewTaxResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/19/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import Foundation

struct UserRegisterNewTaxResponse: Codable {
    let success: Bool
    let data: UserTax
}

struct UserTax: Codable {
    let rucNumber, socialReason: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case rucNumber = "ruc_number"
        case socialReason = "social_reason"
        case id
    }
}

struct UserTaxInfoListResponse: Codable {
    let success: Bool
    let data: [UserTax]
}
