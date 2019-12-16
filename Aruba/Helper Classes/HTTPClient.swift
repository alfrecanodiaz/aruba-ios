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

class HTTPClient {

    static let shared = HTTPClient()

    let baseURL: String = "https://aruba.com.py/api/client/mobile/"
//    let baseURL: String = "https://develop.aruba.com.py/api/client/mobile/"
    
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
        case userRegisterEmail = "user/register/email"
        case userRegisterFacebook = "user/register/facebook"
        case userLogin = "user/login"
        case userModify = "user/update"
        case userAddressAdd = "user/address/create"
        case userAddressList = "user/address/list"
        case userAddressRemove = "user/address/delete"
        case userAddressUpdate = "user/address/update"
        case user = "user/me"
        case serviceCategoryList = "serviceCategory/list"
        case servicesList = "service/list"
        case professionalsFilter = "user/professional/list"
        case bancardPayment = "user/appointment/bancard"
        case cancelBancardPayment = "user/appointment/bancard/cancel"
        case createAppointment = "user/appointment/create"
    }

    lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default

        if AuthManager.isLogged() {
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(AuthManager.getCurrentAccessToken() ?? "")"]
        } else {
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
                                                   "Accept": "application/json"]
        }
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()
    
    func setAccessToken(token: String?) {
        let configuration = URLSessionConfiguration.default
        if let token = token {
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"]
        } else {
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
                                                   "Accept": "application/json"]
        }
        let sessionManager = SessionManager(configuration: configuration)
        HTTPClient.shared.sessionManager = sessionManager
    }

    func request<T: Codable>(method: Mehtod, path: HTTPClient.Endpoint, data: [String: Any]? = nil, completion: @escaping (T?, HTTPClientError?) -> Void) {
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
            parameters["access_token"] = token
        }
        print("Calling endopint: \(path.rawValue) with params: \(parameters)")
        sessionManager.request(url, method: method.value, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    print("Success with data: \(data)")
                    let decoder = JSONDecoder()
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        if (json?["success"] as? Int == 0) {
                            let error = HTTPClientError(message: json?["data"] as? String ?? "Error desconocido.")
                            completion(nil, error)
                            return
                        }
                    } catch(_) {
                        completion(nil, HTTPClientError(message: "Error con el servidor."));
                        return
                    }
                    
                    let result: Result<T> = decoder.decodeResponse(from: response)
                    completion(result.value, nil)
                case .failure(let error):
                    print("error with \(error)")
                    if error._code == NSURLErrorTimedOut {
                        print("Request timeout!")
                        completion(nil, HTTPClientError(message: error.localizedDescription))
                        return
                    }
                    completion(nil, HTTPClientError(message: error.localizedDescription))
                }
        }
    }
}

struct HTTPClientError: Error {
    let message: String
}
