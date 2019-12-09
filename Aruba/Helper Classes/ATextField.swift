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
        accessoryView.backgroundColor = .lightGray
        return accessoryView
    }()
    
    let doneButton: UIButton! = {
        let doneButton = UIButton(type: .custom)
        doneButton.setTitleColor(Colors.ButtonGreen, for: .normal)
        doneButton.setTitle("Listo", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitleColor(.white, for: .disabled)
        doneButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        doneButton.showsTouchWhenHighlighted = true
        doneButton.isEnabled = true
        return doneButton
    }()
    
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
        placeholderFont = UIFont(name: "Lato-Regular", size: 17)
        errorFont = UIFont(name: "Lato-Bold", size: 13)
        font = UIFont(name: "Lato-Regular", size: 17)
        addCustomAccessories()
    }

    func addCustomAccessories() {
//        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
//        let dismissBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "dismissKeyboard"), style: .done, target: self, action: #selector(dismissKeyboard))
////        let dismissBarButton = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissKeyboard))
//
//        toolbar?.tintColor = Colors.ButtonGreen
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        toolbar?.items?.append(flexSpace)
//        toolbar?.items?.append(dismissBarButton)
//        self.inputAccessoryView = toolbar
//        self.inputAccessoryView?.autoresizingMask = .flexibleHeight
        
        
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
