//
//  HTTPClient.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

protocol Fetcher: class {
    associatedtype Generic: Codable
    func fetch(with completion: ((Generic?, Error?) -> Void)?)
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
        let baseURL: String = "https://aruba.com.py/api/client/mobile/" // production
    //    let baseURL: String = "https://develop.aruba.com.py/api/client/mobile/" // develop
    
    //localhost
//    let baseURL: String = "http://192.168.100.12/api/client/mobile/"
    
    enum ApiError: Error {
        case noInternet, api500, api401, noData
    }
    
    enum Mehtod {
        case GET, POST
        
        var value: Alamofire.HTTPMethod {
            switch self {
            case .GET:
                return .get
            case .POST:
                return .post
            }
        }
    }
    
    enum Endpoint: String {
        case userRegisterEmail = "user/register/email"
        case userRegisterFacebook = "user/register/facebook"
        case userLogin = "user/login"
        case userModify = "user/update"
        case userForgotPassword = "user/password/reset"
        case userAddressAdd = "user/address/create"
        case userAddressList = "user/address/list"
        case userAddressRemove = "user/address/delete"
        case userAddressUpdate = "user/address/update"
        case user = "user/me"
        case serviceCategoryList = "serviceCategory/list"
        case servicesList = "service/list"
        case professionalsFilter = "user/professional/list"
        case professionalsFilterWithAvailableSchedules = "user/professional/listAvailable"
        case bancardPayment = "user/appointment/bancard"
        case cancelBancardPayment = "user/appointment/bancard/cancel"
        case createAppointment = "user/appointment/create"
        case appointments = "user/appointment/list"
        case cancelAppointment = "user/appointment/cancel"
        case rateProfessional = "user/review/create"
        case userRegisterDevice = "user/device/create"
        case userDeviceList = "user/device/list"
        case userDeviceUpdate = "user/device/update"
        // tax
        case userTaxCreate = "user/factura/create"
        case userTaxUpdate = "user/factura/update"
        case userTaxDelete = "user/factura/delete"
        case userTaxList = "user/factura/list"
        
        // professionals
        
        case likeProfessional = "user/professional/like"
        case professionalReviewsList = "user/professional/reviews"
        
    }
    
    lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        
        if AuthManager.isLogged() {
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
                                                   "Accept": "application/json",
                                                   "Authorization": "Bearer \(AuthManager.getCurrentAccessToken() ?? "")"]
            print("✅ Access token: \(AuthManager.getCurrentAccessToken() ?? "")")
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
        sessionManager.request(url, method: method.value, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if response.response?.statusCode == 401 {
                        self.showLoginScreen()
                        completion(nil, nil)
                    }
                    if response.response?.statusCode == 503 {
                        completion(nil, HTTPClientError(message: "La plataforma se esta actualizando.. Intente de nuevo mas tarde."))
                    }
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
                    switch result {
                    case .success(let data):
                        Analytics.logEvent("AppDecodingErrorEvent", parameters: [
                            AnalyticsParameterSuccess: 1,
                            "AppParameterRequestParameters": parameters.asString(),
                            "AppParameterRequestRoute": url
                        ])
                        completion(data, nil)
                    case .failure(let error):
                        Analytics.logEvent("AppDecodingErrorEvent", parameters: [
                            AnalyticsParameterSuccess: 0,
                            "AppParameterRequestParameters": parameters.asString(),
                            "AppParameterRequestRoute": url
                        ])
                        completion(nil, HTTPClientError(message: error.localizedDescription))
                    }
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        print("Request timeout!")
                        completion(nil, HTTPClientError(message: "La operación no se pudo completar en este momento."))
                        return
                    }
                    completion(nil, HTTPClientError(message: "Revisa tu conexión a internet."))
                }
        }
    }
    
    private func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandingViewControllerID")
        UIApplication.shared.keyWindow?.rootViewController?.transition(to: vc, completion: nil)
    }
}

struct HTTPClientError: Error {
    let message: String
}

extension Dictionary {
    func asString() -> String {
        var fullString = ""
        self.forEach { key, value in
            fullString += ": \(key) -> \(value) :"
        }
        return fullString
    }
}
