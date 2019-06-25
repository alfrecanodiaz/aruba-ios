//
//  HomeCategoryTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class HomeCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(service: Servicio) {
        contentView.backgroundColor = service.color
        iconImage.image = service.icon
        titleLbl.text = service.titleText
    }

    override func draw(_ rect: CGRect) {
        backgroundImageView.layer.cornerRadius = backgroundImageView.frame.size.height/2
        super.draw(rect)
    }
}
