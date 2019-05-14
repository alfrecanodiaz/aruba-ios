//
//  ATextField.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import MaterialTextField

class ATextField: MFTextField {

    var toolbar: UIToolbar?

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
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let dismissBarButton = UIBarButtonItem(image: UIImage(named: "dismissKeyboard"), style: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar?.items?.append(flexSpace)
        toolbar?.items?.append(dismissBarButton)
        self.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
