//
//  UserAddressListResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/26/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct UserAddressListResponse: Codable {
    let success: Bool
    let data: [AAddress]
}

struct AAddress: Codable {
    let id: Int
    let name: String
    let lat, lng: Double
    let street1, street2, references, number: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, lat, lng, street1, street2, references, number
        case isDefault = "is_default"
    }
}

// MARK: Convenience initializers

extension UserAddressListResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(UserAddressListResponse.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension AAddress {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(AAddress.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
