//
//  DateAssignmentTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/9/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class DateAssignmentTableViewCell: UITableViewCell {

    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var detailsBtn: UIButton! {
        didSet {
            layer.cornerRadius = 8
            clipsToBounds = true
        }
    }

    func configure(person: Person, scheduled: Bool) {
        genderImageView.image = person.gender.image
        genderLbl.text = person.gender.rawValue
        detailsBtn.isHidden = !scheduled
        genderLbl.textColor = scheduled ? .white : .black
        contentView.backgroundColor = scheduled ? UIColor.lightGray : UIColor.white
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
