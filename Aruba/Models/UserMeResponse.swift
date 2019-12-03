//
//  UserMeResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/2/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct UserMeResponse: Codable {
    let success: Bool
    let data: UserMeData
}

struct UserMeData: Codable {
    let id: Int
    let firstName, lastName, email: String
    let emailVerifiedAt, facebookID: JSONNull?
    let enabled: Bool
    let deletedAt: JSONNull?
    let createdAt, updatedAt: String
    let canMakeAppointment: Bool
    let avatarURL: String
    let lastAppointments: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case emailVerifiedAt = "email_verified_at"
        case facebookID = "facebook_id"
        case enabled
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case canMakeAppointment = "can_make_appointment"
        case avatarURL = "avatar_url"
        case lastAppointments = "last_appointments"
    }
}

// MARK: Convenience initializers

extension UserMeResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(UserMeResponse.self, from: data) else { return nil }
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

extension UserMeData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(UserMeData.self, from: data) else { return nil }
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

