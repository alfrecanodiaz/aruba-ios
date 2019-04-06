//
//  BaseViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let backgroundBlackView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}


extension BaseViewController: UIPopoverPresentationControllerDelegate, PopupDelegate {
    
    @objc func popupDidSelectAccept(selectedIndex: Int) {
        removeBlackBackgroundView()
    }
    
    
    func showPopup(title:String, options: [GenericDataCellViewModel], delegate: BaseViewController) -> PopupTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup = storyboard.instantiateViewController(withIdentifier: "PopupTableViewControllerID") as! PopupTableViewController
        popup.delegate = delegate
        popup.titleString = title
        popup.options = options
        addBlackBackgroundView()
        popup.modalPresentationStyle = .popover
        let popover = popup.popoverPresentationController
        popover?.delegate = delegate
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popover?.sourceView = delegate.view
        popover?.sourceRect = CGRect(x: delegate.view.center.x, y: delegate.view.center.y, width: 0, height: 0)
        present(popup, animated: true, completion: nil)
        return popup
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        removeBlackBackgroundView()
    }
    
    
    func removeBlackBackgroundView() {
        UIView.animate(withDuration: 0.34, animations: {
            self.backgroundBlackView.alpha = 0
        }) { (end) in
            self.backgroundBlackView.removeFromSuperview()
        }
    }
    
    func addBlackBackgroundView() {
        self.backgroundBlackView.alpha = 0
        self.view.addSubview(backgroundBlackView)
        UIView.animate(withDuration: 0.34) {
            self.backgroundBlackView.alpha = 1
        }
    }
    
}
