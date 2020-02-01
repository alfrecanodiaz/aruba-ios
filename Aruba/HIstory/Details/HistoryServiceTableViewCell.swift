//
//  HistoryServiceTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/1/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

class HistoryServiceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var serviceImageView: ARoundImage!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
