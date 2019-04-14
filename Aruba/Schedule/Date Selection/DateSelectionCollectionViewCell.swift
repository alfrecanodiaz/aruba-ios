//
//  DateSelectionCollectionViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class DateSelectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roundView: UIView! {
        didSet {
            roundView.layer.cornerRadius = 25
            roundView.clipsToBounds = true
            roundView.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func configure(aDate: AssignmentDate, selected: Bool) {
        if selected {
            roundView.backgroundColor = Colors.ButtonGreen
            descriptionLbl.textColor = .white
            dayLbl.textColor = .white
            roundView.layer.borderColor = Colors.ButtonGreen.cgColor

        } else {
            roundView.backgroundColor = .white
            descriptionLbl.textColor = .lightGray
            dayLbl.textColor = .darkGray
            roundView.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_PY")
        dateFormatter.dateFormat = "EEEE"
        
        if aDate.dateInFuture == 0 {
            dayLbl.text = "HOY"
        } else if aDate.dateInFuture == 1 {
            dayLbl.text = "MAÑANA"
        } else if aDate.dateInFuture == 7 {
            dayLbl.text = "OTRA FECHA"
        } else {
            dayLbl.text = dateFormatter.string(for: aDate.date)?.uppercased()
        }
        dateFormatter.dateFormat = "EEEE dd/MM/yyyy"
        descriptionLbl.text = dateFormatter.string(from: aDate.date).uppercased()
    }
}
