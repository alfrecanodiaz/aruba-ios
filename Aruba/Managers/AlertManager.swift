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
    
    class func showNotice(in viewController: UIViewController,
                          title: String,
                          description: String,
                          completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        configureAlert(alert: alert)
        let aceptar = UIAlertAction(title: "Entendido", style: .cancel, handler: { _ in
            completion?()
        })
        alert.addAction(aceptar)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showNotice(in viewController: UIViewController,
                          title: String,
                          description: String,
                          acceptButtonTitle: String = "Aceptar",
                          completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        configureAlert(alert: alert)
        let aceptar = UIAlertAction(title: acceptButtonTitle, style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(aceptar)
        alert.addAction(UIAlertAction(title: "Atras", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showNotice(in viewController: UIViewController,
                          title: String,
                          description: String,
                          textFieldPlaceholder: String,
                          acceptButtonTitle: String = "Aceptar",
                          completion: ((_ text: String) -> Void)? = nil) {
           let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
           configureAlert(alert: alert)
           let aceptar = UIAlertAction(title: acceptButtonTitle, style: .default, handler: { _ in
                completion?(alert.textFields?.first?.text ?? "")
           })
           alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = textFieldPlaceholder
                textField.font = AFont.with(size: 17, weight: .regular)
            })
           alert.addAction(aceptar)
           alert.addAction(UIAlertAction(title: "Atras", style: .cancel, handler: nil))
           viewController.present(alert, animated: true, completion: nil)
       }
    
    class func showErrorNotice(in viewController: UIViewController,
                       error: HTTPClientError,
                       completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Lo sentimos",
                                      message: error.message,
                                      preferredStyle: .alert)
        configureAlert(alert: alert)
        let aceptar = UIAlertAction(title: "Aceptar",
                                    style: .default,
                                    handler: { _ in
            completion?()
        })
        alert.addAction(aceptar)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func configureAlert(alert: UIAlertController) {
        alert.setTitle(font: AFont.with(size: 15, weight: .bold), color: Colors.alertTitleColor)
        alert.setMessage(font: AFont.with(size: 15, weight: .regular), color: Colors.alertMessageColor)
        alert.view.tintColor = Colors.AlertTintColor
    }
}

extension UIAlertController {

  //Set background color of UIAlertController
  func setBackgroudColor(color: UIColor) {
    if let bgView = self.view.subviews.first,
      let groupView = bgView.subviews.first,
      let contentView = groupView.subviews.first {
      contentView.backgroundColor = color
    }
  }

  //Set title font and title color
  func setTitle(font: UIFont, color: UIColor) {
    guard let title = self.title else { return }
    let attributes: [NSAttributedString.Key : Any] = [.font: font, .foregroundColor: color]
    let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
    self.setValue(attributedString, forKey: "attributedTitle")
  }

  //Set message font and message color
  func setMessage(font: UIFont, color: UIColor) {
    guard let title = self.message else {
      return
    }
    let attributes: [NSAttributedString.Key : Any] = [.font: font, .foregroundColor: color]
    let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
    self.setValue(attributedString, forKey: "attributedMessage")
  }

  func setTint(color: UIColor) {
    self.view.tintColor = color
  }
}
