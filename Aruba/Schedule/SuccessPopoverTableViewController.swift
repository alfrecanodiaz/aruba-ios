//
//  SuccessPopoverTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/16/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol SuccessPopoverDelegate: class {
    func didPressBack()
}

class SuccessPopoverTableViewController: APopoverTableViewController {

    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientAvatarImageView: ARoundImage!
    
    weak var delegate: SuccessPopoverDelegate?
    var clientName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientNameLabel.text = clientName
        guard let urlString = UserManager.shared.loggedUser?.avatarURL, let url = URL(string: urlString) else {
            return
        }
        clientAvatarImageView.kf.setImage(with: url, placeholder: GlobalConstants.userPlaceholder)
    }


    @IBAction func backAction(_ sender: AButton) {
        self.dismiss(animated: true) {
            self.delegate?.didPressBack()
        }
    }
    
}
