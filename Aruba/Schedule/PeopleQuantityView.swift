//
//  PeopleQuantityView.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/8/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

protocol PeopleQuantityViewDelegate: class {
    func quantityDidChange(for peopleQuantityView: PeopleQuantityView, quantity: Int)
}

@IBDesignable
class PeopleQuantityView: UIView, NibLoadable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minusBtn: AButton!
    @IBOutlet weak var plusBtn: AButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    
    let maximum: Int = 99
    var currentCount: Int = 0
    let nibName = "PeopleQuantityView"
    weak var delegate: PeopleQuantityViewDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minusBtn.layer.cornerRadius = 25
        plusBtn.layer.cornerRadius = 25
        minusBtn.tintColor = Colors.ButtonGray
        minusBtn.titleLabel?.font = UIFont(name: "Lato-Bold", size: 50)
        plusBtn.titleLabel?.font = UIFont(name: "Lato-Bold", size: 50)
        minusBtn.backgroundColor = Colors.ButtonGray
    }
    
    enum SelectionType {
        case Woman, Men, Children
    }
    
    func configure(for selectionType: SelectionType) {
        switch selectionType {
        case .Children:
            configureForChildren()
        case .Men:
            configureForMen()
        case .Woman:
            configureForWoman()
        }
    }
    
    func configureForChildren() {
        imageView.image = #imageLiteral(resourceName: "selection_children")
        descriptionLbl.text = "NIÑOS"
    }
    
    func configureForWoman() {
        imageView.image = #imageLiteral(resourceName: "selection_women")
        descriptionLbl.text = "MUJERES"
    }
    
    func configureForMen() {
        imageView.image = #imageLiteral(resourceName: "selection_men")
        descriptionLbl.text = "HOMBRES"
    }
    
    @IBAction func minusAction(_ sender: AButton) {
        if currentCount - 1 < 0 {
            return
        }
        currentCount = currentCount - 1
        delegate?.quantityDidChange(for: self, quantity: currentCount)
        quantityLbl.text = "\(currentCount)"
    }
    
    @IBAction func plusAction(_ sender: AButton) {
        if currentCount + 1 > maximum {
            return
        }
        currentCount = currentCount + 1
        delegate?.quantityDidChange(for: self, quantity: currentCount)
        quantityLbl.text = "\(currentCount)"
    }
    
}
