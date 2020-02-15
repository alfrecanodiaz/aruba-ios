//
//  DateCollectionViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/15/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roundView: UIView! {
        didSet {
            roundView.layer.cornerRadius = 4
            roundView.clipsToBounds = true
            roundView.layer.borderColor = UIColor.darkGray.cgColor
            roundView.layer.borderWidth = 1
        }
    }
}
