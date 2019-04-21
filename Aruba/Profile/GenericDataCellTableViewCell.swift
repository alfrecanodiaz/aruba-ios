//
//  GenericDataCell2TableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class GenericDataCellTableViewCell: UITableViewCell {

    @IBOutlet weak var helperView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var dataLbl: UILabel!

    var viewModel: GenericDataCellViewModel? {
        didSet {
            dataLbl.attributedText = viewModel?.attributedDataString
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        helperView.layer.cornerRadius = 20
        helperView.clipsToBounds = true
        selectionStyle = .none
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        deleteBtn.layer.cornerRadius = deleteBtn.bounds.width/2
        deleteBtn.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
