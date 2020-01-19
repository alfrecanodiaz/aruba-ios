//
//  UserRegisterDeviceResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/19/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import Foundation

struct UserRegisterDeviceResponse: Codable {
    let success: Bool
    let data: Device
}

struct Device: Codable {
    let version, phoneNumber, pushToken, os: String?
    let model: String?
    let id: Int

    enum CodingKeys: String, CodingKey {
        case version
        case phoneNumber = "phone_number"
        case pushToken = "push_token"
        case os, model, id
    }
}
