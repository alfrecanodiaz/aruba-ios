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

    enum Endpoint: String {
        case userRegister = "users/add"
        case userLogin = "users/login"
        case userModify = "users/modify"
    }

    static let baseURL: String = "https://181.120.219.8:8443/aruba_war/"

    static func request<T: Codable>(method: Mehtod, path: HTTPClient.Endpoint ,data: [String:String]? = nil, completion: @escaping (T?, Error?) -> Void) {
        let url = baseURL + path.rawValue
        Alamofire.request(url, method: method.value, parameters: data)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print("Success with data: \(data)")
                    let decoder = JSONDecoder()
                    let result: Result<T> = decoder.decodeResponse(from: response)
                    completion(result.value, result.error)
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        print("Request timeout!")
                    }
                    print("error with \(error)")
                }
        }
    }
}
