//
//  HomeCategoryTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var disabledMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(category: CategoryViewModel) {
        contentView.backgroundColor = category.color
        iconImage.image = category.image
        titleLbl.text = category.title
        if let url = URL(string: category.imageURL ?? "") {
            iconImage.kf.setImage(with: url, placeholder: GlobalConstants.imagePlaceholder)
        }
        disabledMessageLabel.isHidden = category.enabled
        disabledMessageLabel.text = category.inactiveText
        iconImage.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        iconImage.image = nil
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
