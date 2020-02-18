//
//  ProfileHeaderTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var greetingLbl: UILabel!
    @IBOutlet weak var profileImageView: ARoundImage!

    override func awakeFromNib() {
        super.awakeFromNib()
        guard let loggedUser = UserManager.shared.loggedUser else { return }
        greetingLbl.text = "¡Hola \(loggedUser.firstName)!"
        guard let url = URL(string: UserManager.shared.loggedUser?.avatarURL ?? "") else { return }
        profileImageView.hnk_setImageFromURL(url, placeholder: GlobalConstants.userPlaceholder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func draw(_ rect: CGRect) {
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
        super.draw(rect)
    }

}
