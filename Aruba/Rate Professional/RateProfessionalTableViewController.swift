//
//  RateProfessionalTableViewController.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/3/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import Cosmos

struct RateProfessionalViewModel {
    let professionalName: String
    let professionalAvatarURL: String
    let professionalId: Int
}

protocol RateProfessionalPopupDelegate: class {
    func didClosePopup()
    func didRateProfessional()
}

class RateProfessionalTableViewController: APopoverTableViewController {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var professionalAvatarImageView: ARoundImage!
    @IBOutlet weak var commentsTextField: ATextField!
    // Inject in prepareForSegue
    var viewModel: RateProfessionalViewModel!
    weak var delegate: RateProfessionalPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        professionalNameLabel.text = viewModel.professionalName
        professionalAvatarImageView.avatarFrom(urlString: viewModel.professionalAvatarURL)
        guard let loggedUser = UserManager.shared.loggedUser else {
            return
        }
        userNameLabel.text = loggedUser.fullName()

    }

    
    @IBAction func closeAction(_ sender: Any) {
        delegate?.didClosePopup()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateAction(_ sender: UIButton) {
        
        ALoader.show()
        let params: [String: Any] = ["user_id": viewModel.professionalId, "rating_number": Int(cosmosView.rating), "text": commentsTextField.text ?? ""]
        HTTPClient.shared.request(method: .POST, path: .rateProfessional, data: params) { (response: RateProfessionalResponse?, error) in
            ALoader.hide()
            if let _ = response {
                self.showSuccess()
                self.delegate?.didRateProfessional()
                self.dismiss(animated: true, completion: nil)
            } else if let error = error {
                AlertManager.showNotice(in: self, title: "Lo sentimos", description: error.message)
            }
        }
        
        
    }
    
    
}


extension Professional {
    func fullName() -> String {
        return firstName + " " + lastName
    }
}

extension User {
    func fullName() -> String {
        return firstName + " " + lastName
    }
}

extension UIImageView {
    func avatarFrom(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        kf.setImage(with: url, placeholder: GlobalConstants.userPlaceholder)
    }
}
