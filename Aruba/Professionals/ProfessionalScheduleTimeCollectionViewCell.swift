//
//  ProfessionalScheduleTimeCollectionViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/15/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

class ProfessionalScheduleTimeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: APaddedLabel! {
        didSet {
            timeLabel.layer.borderColor = UIColor.darkGray.cgColor
            timeLabel.layer.borderWidth = 0.5
            timeLabel.layer.cornerRadius = 8
            timeLabel.clipsToBounds = true
            timeLabel.font = AFont.with(size: 12, weight: .regular)
        }
    }
    enum Constants {
        static let reuseIdentifier = "ProfessionalScheduleTimeReuseID"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSelected(_ selected: Bool) {
        timeLabel.layer.borderColor = selected ? Colors.AlertTintColor.cgColor : UIColor.darkGray.cgColor
        timeLabel.textColor = selected ? .white : .darkGray
        timeLabel.backgroundColor = selected ? Colors.AlertTintColor : .clear
    }

}
