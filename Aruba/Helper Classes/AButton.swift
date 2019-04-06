//
//  AButton.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

class AButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    private let cornerRadius: CGFloat = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.ButtonGreen
        titleLabel?.textColor = .white
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
    }
    
}
