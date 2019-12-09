//
//  ProfessionalTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfessionalTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton! {
        didSet {
            likeBtn.imageView?.contentMode = .scaleAspectFit
        }
    }

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var profileImageView: ARoundImage!
    
    func configure(professional: Professional) {
        nameLbl.text = professional.firstName + " " + professional.lastName
        guard let url = URL(string: professional.avatarURL) else { return }
        profileImageView.hnk_setImageFromURL(url, placeholder: Constants.userPlaceholder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
