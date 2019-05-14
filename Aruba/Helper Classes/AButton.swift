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

    private var enabledColor: UIColor? = Colors.ButtonGreen
    private var disabledColor: UIColor? = Colors.ButtonGray

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyles()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyles()
    }

    private func applyStyles() {
        backgroundColor = buttonColor
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont(name: "Lato-Bold", size: 14)
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

    func setEnabled(_ enabled: Bool) {
        isUserInteractionEnabled = enabled
        UIView.animate(withDuration: 0.35) {
            self.backgroundColor = enabled ? self.enabledColor : self.disabledColor
        }
    }

    @IBInspectable var buttonColor: UIColor? {
        set {
            self.backgroundColor = newValue
            self.enabledColor = newValue
        }
        get {
            return self.enabledColor ?? Colors.ButtonGreen
        }
    }

    @IBInspectable var highlightColor: UIColor = Colors.ButtonHighlightedGreen

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = highlightColor
            } else {
                self.backgroundColor = enabledColor
            }
        }
    }

}
