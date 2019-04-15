//
//  BaseNavigationController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*CGFloat(0.5), height: 15))
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "ARUBA_LOGO-BLANCO")
        viewControllers.first?.navigationItem.titleView = imgView
    }
    

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*CGFloat(0.5), height: 15))
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "ARUBA_LOGO-BLANCO")
        viewController.navigationItem.titleView = imgView
    }
}
