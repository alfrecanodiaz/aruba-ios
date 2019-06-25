//
//  APopoverTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class APopoverTableViewController: BaseTableViewController {

    private var kvoContext = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver(self, forKeyPath: #keyPath(tableView.contentSize), options: .new, context: &kvoContext)

    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObserver(self, forKeyPath: #keyPath(tableView.contentSize))
        super.viewDidDisappear(animated)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kvoContext, keyPath == #keyPath(tableView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            self.popoverPresentationController?.presentedViewController.preferredContentSize = contentSize
        }
    }
}
