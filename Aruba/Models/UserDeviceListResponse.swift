//
//  UserDeviceListResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/19/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import Foundation

struct UserDeviceListResponse: Codable {
    let success: Bool
    let data: [Device]
}
