//
//  ServiceCategoryListResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/2/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct ServiceCategoryListResponse: Codable {
    let success: Bool
    let data: [ServiceCategory]
}

struct ServiceCategory: Codable {
    let id: Int
    let name, displayName: String
    let description: String?
    let enabled: Bool
    let color, inactiveText: String?
    let order: Int?
    let imageURL: String
    let clientTypes: [ClientType]
    let subCategories: [ServiceCategory]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case description, enabled, color
        case inactiveText = "inactive_text"
        case order
        case imageURL = "image_url"
        case clientTypes = "client_types"
        case subCategories = "sub_categories"
    }
}

struct ClientType: Codable {
    let id: Int
    let name, displayName: Name

    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
    }
}

enum Name: String, Codable {
    case hombre = "Hombre"
    case mujer = "Mujer"
}

// MARK: Convenience initializers

extension ServiceCategoryListResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(ServiceCategoryListResponse.self, from: data) else { return nil }
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

extension ServiceCategory {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(ServiceCategory.self, from: data) else { return nil }
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

extension ClientType {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(ClientType.self, from: data) else { return nil }
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
