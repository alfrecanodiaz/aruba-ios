//
//  ServiceSelectionTableViewCell.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol ServiceSelectionTableViewCellDelegate: class {
    func didSelectProduct(selected: Bool, at indexPath: IndexPath)
    func didSelectViewProductDescription(at indexPath: IndexPath)

}

class ServiceSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var productSwitch: UISwitch!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        detailBtn.backgroundColor = Colors.ButtonGray
        detailBtn.layer.cornerRadius = 6
        detailBtn.clipsToBounds = true
        detailBtn.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    var indexPath: IndexPath!
    
    weak var delegate: ServiceSelectionTableViewCellDelegate?
    
    func configure(product: Product ,isSelected: Bool, indexPath: IndexPath) {
        productSwitch.setOn(isSelected, animated: false)
        productName.text = product.name
        self.indexPath = indexPath
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        delegate?.didSelectProduct(selected: sender.isOn, at: indexPath)
    }
    
    @IBAction func detailAction(_ sender: UIButton) {
        delegate?.didSelectViewProductDescription(at: indexPath)
    }
    
}
