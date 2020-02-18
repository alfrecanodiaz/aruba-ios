//
//  CalendarDayCollectionViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/17/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDayCollectionViewCell: JTACDayCell {
    
    @IBOutlet weak var backgroundRoundView: UIView! {
        didSet {
            backgroundRoundView.layer.cornerRadius = 15
            backgroundRoundView.clipsToBounds = true
            backgroundRoundView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
        }
    }
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func setSelected(_ selected: Bool) {
        backgroundRoundView.backgroundColor = selected ? Colors.Greens.calendarSelected : Colors.Whites.calendarUnselected
        dateLabel.textColor = selected ? .white : Colors.Greens.calendarLabel
    }
}
