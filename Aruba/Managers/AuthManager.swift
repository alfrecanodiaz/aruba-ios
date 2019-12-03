//
//  LoginManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import FBSDKLoginKit

struct LoginViewModel {
    let user: User
}

class BaseError: Error {
    
}

class AuthError: BaseError {
    
}

class LoginError: AuthError {
    
    enum Cause {
        case wrongCredentials
        
        var description: String {
            switch self {
            case .wrongCredentials:
                return "Credenciales invalidas"
            }
        }
    }
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
                AuthManager.setUserLogged(isLogged: true)
                AuthManager.setCurrentAccessToken(token: response.data.accessToken)
                UserManager.shared.loggedUser = response.data.user
                completion(response, nil)
            } else {
                completion(nil, error)
            }
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
                print(response)
                
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
    
    static func registerFacebook(isRegister: Bool, token: String,
                                 completion: @escaping (LoginViewModel?, LoginError?) -> Void) {
        let data: [String: Any] = ["facebook_token": token]
        HTTPClient.shared.request(method: .POST, path: .userRegisterFacebook, data: data) { (loginResponse: UserLoginResponse?, error) in
            if let response = loginResponse {
                print(response)
                let loginVM = LoginViewModel(user: response.data.user)
                AuthManager.setUserLogged(isLogged: true)
                AuthManager.setCurrentAccessToken(token: response.data.accessToken)
                UserManager.shared.loggedUser = response.data.user
                completion(loginVM, nil)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil, error as? LoginError)
            }
        }
    }
    
    static func loginWithFacebook(from viewController: UIViewController, completion: ((_: LoginViewModel?, _: Error?) -> Void)? = nil) {
        AuthManager.fbLoginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let result = result else { return }
                if result.isCancelled {
                    print("Canceled")
                } else {
                    guard let token = result.token else { return }
                    print("fb token: ", token.tokenString)
                    
                    AuthManager.registerFacebook(isRegister: false, token: token.tokenString,
                                                 completion: { (loginVM, error) in
                                                    if let error = error {
                                                        print(error.localizedDescription)
                                                        completion?(nil, error)
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
            print(response, error)
            
            completion(response, error)
        }
    }
    
}
