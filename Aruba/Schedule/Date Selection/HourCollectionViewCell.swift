//
//  HourCollectionViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class HourCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 20
            containerView.clipsToBounds = true
            containerView.layer.borderColor = UIColor.lightGray.cgColor
            containerView.layer.borderWidth = 1
        }
    }

    func configure(hour: Hour, selected: Bool) {
        hourLbl.text = hour.hourString
        if selected {
            containerView.backgroundColor = .lightGray
        } else {
            containerView.backgroundColor = .white
        }
    }

}
