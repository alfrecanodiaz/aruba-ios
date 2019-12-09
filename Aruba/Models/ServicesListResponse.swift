//
//  ServicesListResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/22/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

struct ServicesListResponse: Codable {
    let success: Bool
    let data: [Service]
}

struct Service: Codable {
    let id: Int
    let name, displayName, description: String
    let enabled: Bool
    let price, duration: Int
    let isPromotion: Bool
    let imageURL: String
    let categories: [ServiceCategory]

    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case description, enabled, price, duration
        case isPromotion = "is_promotion"
        case imageURL = "image_url"
        case categories
    }
}


// MARK: Convenience initializers

extension ServicesListResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(ServicesListResponse.self, from: data) else { return nil }
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

extension Service {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Service.self, from: data) else { return nil }
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
