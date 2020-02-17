//
//  ATextField.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import MaterialTextField

protocol ATextFieldDelegate: class {
    func didPressDone(textField: ATextField)
}
class ATextField: MFTextField {

    var toolbar: UIToolbar?
    weak var aDelegate: ATextFieldDelegate?
    
    
    lazy var accessory: UIView = {
        let accessoryView = UIView(frame: .zero)
        accessoryView.backgroundColor = Colors.ButtonGreen
        return accessoryView
    }()
    
    let doneButton: UIButton! = {
        let doneButton = UIButton(type: .custom)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.setTitleColor(.white, for: .highlighted)
        doneButton.setTitleColor(.white, for: .selected)
        doneButton.setTitle("Listo", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitleColor(.white, for: .disabled)
        doneButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        doneButton.showsTouchWhenHighlighted = true
        doneButton.isEnabled = true
        return doneButton
    }()
    
    enum Styles {
        static let textColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.6666666667, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyles()
    }

    private func applyStyles() {
        tintColor = Colors.ButtonGreen
        placeholderFont = AFont.with(size: 15, weight: .regular)
        errorFont = UIFont(name: "Lato-Bold", size: 13)
        textColor = Styles.textColor
        font = AFont.with(size: 15, weight: .regular)
        addCustomAccessories()
    }

    func addCustomAccessories() {
        accessory.frame = CGRect(x: 0, y: 0, width: frame.width, height: 45)
        accessory.translatesAutoresizingMaskIntoConstraints = false
        inputAccessoryView = accessory
        accessory.addSubview(doneButton)
        NSLayoutConstraint.activate([
        doneButton.trailingAnchor.constraint(equalTo:
        accessory.trailingAnchor, constant: -20),
        doneButton.centerYAnchor.constraint(equalTo:
        accessory.centerYAnchor)
        ])
    }

    @objc func dismissKeyboard() {
        aDelegate?.didPressDone(textField: self)
        self.resignFirstResponder()
    }
}
