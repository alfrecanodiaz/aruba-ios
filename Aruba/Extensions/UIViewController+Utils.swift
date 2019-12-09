//
//  UIViewController+Utils.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func transition(to viewController: UIViewController, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        guard let rootViewController = window.rootViewController else {
            return
        }

        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }, completion: { _ in
            completion?()
        })
    }
}
