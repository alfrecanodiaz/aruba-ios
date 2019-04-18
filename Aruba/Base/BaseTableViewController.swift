//
//  BaseTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var entryAnimationDone: Bool = false

    let backgroundBlackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !entryAnimationDone {
            cell.transform = CGAffineTransform(translationX: 0, y: 40)
            cell.alpha = 0
            UIView.animate(withDuration: 0.3, delay: TimeInterval(0.1*Double(indexPath.row)), usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }) { (end) in
                self.entryAnimationDone = true
            }
        }
    }


}

extension BaseTableViewController: UIPopoverPresentationControllerDelegate, PopupDelegate {
    
    @objc func popupDidSelectAccept(selectedIndex: Int) {
        removeBlackBackgroundView()
    }
    
    
    func showOptionPopup(title:String, options: [GenericDataCellViewModel], delegate: BaseTableViewController) -> PopupTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popup = storyboard.instantiateViewController(withIdentifier: "PopupTableViewControllerID") as! PopupTableViewController
        popup.delegate = delegate
        popup.titleString = title
        popup.options = options
        popup.modalPresentationStyle = .popover
        addBlackBackgroundView()
        let popover = popup.popoverPresentationController
        popover?.delegate = delegate
        popover?.permittedArrowDirections = .init(rawValue: 0)
        popover?.sourceView = view
        popover?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
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
