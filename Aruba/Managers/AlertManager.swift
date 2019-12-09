//
//  AlertManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/3/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    class func showNotice(in viewController: UIViewController, title: String, description: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.view.tintColor = Colors.ButtonGreen
        let aceptar = UIAlertAction(title: "Entendido.", style: .cancel, handler: { _ in
            completion?()
        })
        alert.addAction(aceptar)
        viewController.present(alert, animated: true, completion: nil)
    }
}
