//
//  LoginManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct LoginViewModel {

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

class AuthManager {

    static func login(username: String, password: String, completion: @escaping (LoginViewModel?, LoginError?) -> Void) {

        HTTPClient.request(method: .POST, path: .userLogin) { (user: AUser?, error) in
            if let user = user {
                print(user)
            } else {
                print(error?.localizedDescription)
            }
        }

    }

    static func registerFacebook(firstName: String,
                                 lastName: String,
                                 email: String,
                                 token: String,
                                 completion: @escaping (LoginViewModel?, LoginError?) -> Void) {
        let data = ["firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "facebookToken": token]
        HTTPClient.request(method: .POST, path: .userRegister, data: data) { (user: AUser?, error) in
            if let user = user {
                print(user)
            } else {
                print(error?.localizedDescription)
            }
        }
    }

}
