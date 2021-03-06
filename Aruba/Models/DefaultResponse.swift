//
//  DefaultResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/17/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct DefaultResponse: Codable {
    let success: Bool
    let data: JSONAny
}

struct DefaultResponseAsString: Codable {
    let success: Bool
    let data: String
}

// MARK: Convenience initializers

extension DefaultResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return nil }
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

