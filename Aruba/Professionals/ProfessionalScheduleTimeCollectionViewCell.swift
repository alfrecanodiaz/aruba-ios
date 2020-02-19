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
            timeLabel.layer.borderColor = Colors.Grays.enabledDateText.cgColor
            timeLabel.layer.borderWidth = 0.5
            timeLabel.layer.cornerRadius = 5
            timeLabel.clipsToBounds = true
            timeLabel.textColor = Colors.Grays.enabledDateText
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
        timeLabel.layer.borderColor = selected
            ? Colors.Greens.calendarSelected.cgColor
            : Colors.Grays.enabledDateText.cgColor
        timeLabel.textColor = selected
            ? .white
            : Colors.Grays.enabledDateText
        timeLabel.backgroundColor = selected
            ? Colors.Greens.calendarSelected
            : .clear
    }
    
    func setEnabled(_ enabled: Bool) {
        timeLabel.textColor = enabled
            ? Colors.Grays.enabledDateText
            : Colors.Grays.disabledDateText
        timeLabel.layer.borderColor = enabled
            ? Colors.Grays.enabledDateText.cgColor
            : Colors.Grays.disabledDateText.cgColor
    }

}
