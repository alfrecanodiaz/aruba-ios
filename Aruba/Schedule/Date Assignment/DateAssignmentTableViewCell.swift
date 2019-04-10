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
    
    func configure(person: Person) {
        genderImageView.image = person.gender.image
        genderLbl.text = person.gender.rawValue
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
