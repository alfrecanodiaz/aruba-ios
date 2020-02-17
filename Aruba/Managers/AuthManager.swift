//
//  LoginManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

struct LoginViewModel {
    let user: User
}

final class AuthManager {
    
    static let fbLoginManager: LoginManager = {
        return LoginManager()
    }()
    
    fileprivate static let UserLoggedKey = "UserLoggedKey"
    fileprivate static let UserAccessTokenKey = "UserAccessTokenKey"
    
    static func isLogged() -> Bool {
        return UserDefaults.standard.bool(forKey: UserLoggedKey)
    }
    
    static func setUserLogged(isLogged: Bool) {
        UserDefaults.standard.set(isLogged, forKey: UserLoggedKey)
    }
    
    static func getCurrentAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: UserAccessTokenKey)
    }
    
    static func setCurrentAccessToken(token: String?) {
        HTTPClient.shared.setAccessToken(token: token)
        UserDefaults.standard.set(token, forKey: UserAccessTokenKey)
    }
    
    static func logout() {
        fbLoginManager.logOut()
        AuthManager.setUserLogged(isLogged: false)
        AuthManager.setCurrentAccessToken(token: nil)
        UserManager.shared.loggedUser = nil
    }
    
    static func login(username: String, password: String, completion: @escaping (UserLoginResponse?, HTTPClientError?) -> Void) {
        let params: [String: Any] = ["email": username, "password": password]
        HTTPClient.shared.request(method: .POST, path: .userLogin, data: params) { (loginResponse: UserLoginResponse?, error) in
            if let response = loginResponse {
                Analytics.logEvent(AnalyticsEventLogin, parameters: [
                    AnalyticsParameterSuccess: 1,
                    "AppParameterUserId": response.data.user.id
                ])
                AuthManager.setUserLogged(isLogged: true)
                AuthManager.setCurrentAccessToken(token: response.data.accessToken)
                UserManager.shared.loggedUser = response.data.user
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func resetPassword(email: String, completion: @escaping (String?, HTTPClientError?) -> Void) {
        let params = ["email": email]
        HTTPClient.shared.request(method: .POST, path: .userForgotPassword, data: params) { (resetResponse: DefaultResponseAsString?, error) in
            completion(resetResponse?.data, error)
        }
    }
    
    static func registerEmail(firstName: String,
                              lastName: String,
                              username: String,
                              password: String,
                              completion: @escaping (LoginViewModel?, HTTPClientError?) -> Void) {
        let params: [String: Any] = ["first_name": firstName,
                                     "last_name": lastName,
                                     "email": username,
                                     "password": password]
        HTTPClient.shared.request(method: .POST, path: .userRegisterEmail, data: params) { (loginResponse: UserLoginResponse?, error) in
            if let response = loginResponse {
                Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                    AnalyticsParameterSuccess: 1,
                    AnalyticsParameterSignUpMethod: "email",
                    "AppParameterUserId": response.data.user.id
                ])
                let loginVM = LoginViewModel(user: response.data.user)
                AuthManager.setUserLogged(isLogged: true)
                AuthManager.setCurrentAccessToken(token: response.data.accessToken)
                UserManager.shared.loggedUser = response.data.user
                completion(loginVM, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func registerFacebook(token: String,
                                 completion: @escaping (LoginViewModel?, HTTPClientError?) -> Void) {
        let data: [String: Any] = ["facebook_token": token]
        HTTPClient.shared.request(method: .POST, path: .userRegisterFacebook, data: data) { (loginResponse: UserLoginResponse?, error) in
            if let response = loginResponse {
                let loginVM = LoginViewModel(user: response.data.user)
                Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                    AnalyticsParameterSuccess: 1,
                    AnalyticsParameterSignUpMethod: "facebook",
                    "AppParameterUserId": response.data.user.id
                ])
                AuthManager.setUserLogged(isLogged: true)
                AuthManager.setCurrentAccessToken(token: response.data.accessToken)
                UserManager.shared.loggedUser = response.data.user
                completion(loginVM, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func loginWithFacebook(from viewController: UIViewController, completion: ((_: LoginViewModel?, _: String?) -> Void)? = nil) {
        AuthManager.fbLoginManager.logOut()
        AuthManager.fbLoginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
            if let error = error {
                completion?(nil, error.localizedDescription)
            } else {
                guard let result = result else { return }
                if result.isCancelled {
                    completion?(nil, "Cancelado por el usuario.")
                } else {
                    guard let token = result.token else { return }
                    AuthManager.registerFacebook(token: token.tokenString,
                                                 completion: { (loginVM: LoginViewModel?, error) in
                                                    if let error = error {
                                                        print(error.localizedDescription)
                                                        completion?(nil, error.message)
                                                    } else {
                                                        completion?(loginVM, nil)
                                                    }
                    })
                }
                
            }
        }
    }
    
    static func fetchUser(completion: @escaping (UserMeResponse?, HTTPClientError?) -> Void) {
        HTTPClient.shared.request(method: .POST, path: .user) { (response: UserMeResponse?, error) in
            if let user = response?.data {
                UserManager.shared.loggedUser = User(firstName: user.firstName,
                                                     lastName: user.lastName,
                                                     email: user.email,
                                                     updatedAt: user.updatedAt,
                                                     facebook_id: user.facebookID ?? "",
                                                     createdAt: user.createdAt,
                                                     id: user.id,
                                                     canMakeAppointment: user.canMakeAppointment,
                                                     avatarURL: user.avatarURL,
                                                     addresses: [],
                                                     appointments: [])
            }
            completion(response, error)
        }
    }
    
}
