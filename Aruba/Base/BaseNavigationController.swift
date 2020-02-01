//
//  BaseNavigationController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    private lazy var logoView: UIView = {
        self.makeLogoView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.first?.navigationItem.titleView = logoView
    }
    
    private func makeLogoView() -> UIView {
        let view = UIView(frame: CGRect(x: navigationBar.center.x - 80, y: 0, width: 160, height: navigationBar.bounds.height))
        let imgView = UIImageView(image: UIImage(named: "ARUBA_LOGO"))
        imgView.contentMode = .scaleAspectFit
        view.addSubviewConstrained(subview: imgView)
        return view
    }
    
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.titleView = logoView
    }
}

extension UIView {
    func addSubviewConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.topAnchor),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
