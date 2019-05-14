//
//  HTTPClient.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import Alamofire

protocol Fetcher: class {
    associatedtype Generic: Codable
    func fetch(with completion: ((Generic?, Error?) -> Void)?)
}

class HTTPClient: Fetcher {
    typealias T = AAddress
    typealias P = Codable
//    typealias T = Result<P>

    func fetch(with completion: ((HTTPClient.T?, Error?) -> Void)?) {

    }

    static let shared = HTTPClient()

    let baseURL: String = "http://159.89.26.89:8080/aruba_war/"

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
        case userAddressAdd = "users/address/add"
    }

    lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()

    func request<T: Codable>(method: Mehtod, path: HTTPClient.Endpoint, data: [String: Any]? = nil, completion: @escaping (T?, Error?) -> Void) {
        let url = baseURL + path.rawValue
        var parameters = [String: Any]()
        if let data = data {
            parameters = data
        }
        if AuthManager.isLogged() {
            guard let token = AuthManager.getCurrentAccessToken() else {
                print("Tried to retrieve access token from Auth Manager but there is not one stored.")
                return
            }
            parameters["token"] = token
        }
        sessionManager.request(url, method: method.value, parameters: parameters, encoding: JSONEncoding.default)
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
