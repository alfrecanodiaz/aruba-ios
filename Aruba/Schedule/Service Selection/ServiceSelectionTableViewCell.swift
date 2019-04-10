//
//  ServiceSelectionTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class ServiceSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var detailBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailBtn.backgroundColor = Colors.ButtonGray
        detailBtn.layer.cornerRadius = 6
        detailBtn.clipsToBounds = true
        detailBtn.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
