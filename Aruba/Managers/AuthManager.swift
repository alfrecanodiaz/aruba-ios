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
    let firstName: String
    let lastName: String
    let email: String
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

    static let fbLoginManager: FBSDKLoginManager = {
        return FBSDKLoginManager()
    }()

    fileprivate static let UserLoggedKey = "UserLoggedKey"

    static func isLogged() -> Bool {
        return UserDefaults.standard.bool(forKey: UserLoggedKey)
    }

    static func setUserLogged(isLogged: Bool) {
        UserDefaults.standard.set(isLogged, forKey: UserLoggedKey)
    }

    static func login(username: String, password: String, completion: @escaping (LoginViewModel?, LoginError?) -> Void) {

        HTTPClient.request(method: .POST, path: .userLogin) { (user: AUser?, error) in
            if let user = user {
                print(user)
                AuthManager.setUserLogged(isLogged: true)
            } else {
                print(error?.localizedDescription ?? "")
            }
        }

    }

    static func logout() {
        fbLoginManager.logOut()
        AuthManager.setUserLogged(isLogged: false)
    }

    static func registerFacebook(token: String,
                                 completion: @escaping (LoginViewModel?, LoginError?) -> Void) {
        let data = [
            "idPerfil": 3,
            "facebookAccessToken": token] as [String: Any?
        ]
        HTTPClient.request(method: .POST, path: .userLogin, data: data) { (user: AUser?, error) in
            if let user = user {
                print(user)
                let loginVM = LoginViewModel(firstName: user.userSession.usuario.nombres,
                                             lastName: user.userSession.usuario.apellidos,
                                             email: user.userSession.usuario.email)
                setUserLogged(isLogged: true)
                completion(loginVM, nil)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil, error as? LoginError)
            }
        }
    }

    static func loginWithFacebook(from viewController: UIViewController, completion: ((_: Error?) -> Void)? = nil) {
        AuthManager.fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let result = result else { return }
                if result.isCancelled {
                    print("Canceled")
                } else {
                    guard let token = result.token else { return }

                    AuthManager.registerFacebook(token: token.tokenString,
                                                 completion: { (_, error) in
                                                    if let error = error {
                                                        print(error.localizedDescription)
                                                        completion?(error)
                                                    } else {
                                                        completion?(nil)
                                                    }
                    })
                }

            }
        }
    }

}
