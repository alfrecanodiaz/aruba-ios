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
    }
    
}
