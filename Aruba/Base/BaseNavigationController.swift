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
//        viewControllers.first?.navigationItem.titleView = makeLogoView(constrainedTo: viewControllers.first?.navigationItem)
//        addLogoImage(image: UIImage(named: "ARUBA_LOGO")!, navItem: viewControllers.first?.navigationItem ?? navigationItem)
        makeLogoView(constrainedTo: viewControllers.first!.navigationItem)
    }
    
    private func makeLogoView(constrainedTo navigationItem: UINavigationItem) {
        let view = UIView(frame: CGRect(x: navigationBar.center.x - 80, y: 0, width: 160, height: navigationBar.bounds.height))
        let imgView = UIImageView(image: UIImage(named: "ARUBA_LOGO"))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        view.addSubview(imgView)
        imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imgView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(navigationItem.leftBarButtonItem?.width ?? 0)).isActive = true
        navigationItem.titleView = view
//        view.addSubviewConstrained(subview: imgView, insets: UIEdgeInsets(top: 10, left: naviga, bottom: 10, right: 80))
    }
    
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        makeLogoView(constrainedTo: viewController.navigationItem)

//        addLogoImage(image: UIImage(named: "ARUBA_LOGO")!, navItem: viewController.navigationItem)

    }
    
    func addLogoImage(image: UIImage, navItem: UINavigationItem) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        view.addSubview(imageView)

        navItem.titleView = view
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

//        view.heightAnchor.constraint(equalTo: navigationBar.heightAnchor).isActive = true
//        view.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
//        view.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
    }
}

extension UIView {
    func addSubviewConstrained(subview: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right),
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
