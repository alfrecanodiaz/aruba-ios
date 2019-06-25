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
    let addresses: [AddressViewModel]
    let user: UserLoginResponse
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
    }

    static func login(username: String?, password: String?, facebookToken: String?, completion: @escaping (UserLoginResponse?, LoginError?) -> Void) {
        let params: [String: Any] = ["usuario": username, "password": password, "facebookAccessToken": facebookToken]
        HTTPClient.shared.request(method: .POST, path: .userLogin, data: params) { (user: UserLoginResponse?, error) in
            if let user = user {
                print(user)
                AuthManager.setUserLogged(isLogged: true)
                AuthManager.setCurrentAccessToken(token: user.sesion.token)
                completion(user, nil)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil, error as? LoginError)
            }
        }
    }

    static func registerEmail(firstName: String,
                              lastName: String,
                              username: String,
                              password: String,
                              completion: @escaping (LoginViewModel?, LoginError?) -> Void) {
        let params: [String: Any] = ["nombres": firstName,
                                     "apellidos": lastName,
                                     "emailUsuario": username,
                                     "passUsuario": password,
                                     "idPerfil": 3]
        HTTPClient.shared.request(method: .POST, path: .userRegisterEmail, data: params) { (user: UserLoginResponse?, error) in
            if let user = user {
                print(user)
                AuthManager.setUserLogged(isLogged: true)
                AuthManager.setCurrentAccessToken(token: user.sesion.token)
                let loginVM = LoginViewModel(firstName: user.sesion.usuario.nombres,
                                             lastName: user.sesion.usuario.apellidos,
                                             email: user.sesion.usuario.email,
                                             addresses: user.sesion.usuario.ubicaciones.map({AddressViewModel(address: $0)}),
                                             user: user)
                setUserLogged(isLogged: true)
                setCurrentAccessToken(token: user.sesion.token)
                completion(loginVM, nil)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil, error as? LoginError)
            }
        }
    }

    static func registerFacebook(isRegister: Bool, token: String,
                                 completion: @escaping (LoginViewModel?, LoginError?) -> Void) {
        let data: [String: Any] = ["facebook_token": token]
        HTTPClient.shared.request(method: .POST, path: .userRegisterFacebook, data: data) { (user: UserLoginResponse?, error) in
            if let user = user {
                print(user)
                let loginVM = LoginViewModel(firstName: user.sesion.usuario.nombres,
                                             lastName: user.sesion.usuario.apellidos,
                                             email: user.sesion.usuario.email,
                                             addresses: user.sesion.usuario.ubicaciones.map({AddressViewModel(address: $0)}),
                                             user: user)
                setUserLogged(isLogged: true)
                setCurrentAccessToken(token: user.sesion.token)
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

}
