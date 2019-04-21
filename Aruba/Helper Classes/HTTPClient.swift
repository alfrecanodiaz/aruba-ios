//
//  HTTPClient.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import Alamofire

class HTTPClient {

    enum ApiError: Error {
        case noInternet, api500, api401, noData
    }

    enum Mehtod {
        case GET, POST

        var value: Alamofire.HTTPMethod {
            switch self {
            case .GET:
                return Alamofire.HTTPMethod.get
            case .POST:
                return Alamofire.HTTPMethod.post
            }
        }
    }

    static let baseURL: String = "http://" // TODO: get real server address

    static func request<T: Codable>(method: Mehtod, path: String, completion: @escaping (T?, Error?) -> Void) {
        let url = baseURL + path
        Alamofire.request(url, method: method.value)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<T> = decoder.decodeResponse(from: response)
                completion(result.value, result.error)
        }
    }
}
