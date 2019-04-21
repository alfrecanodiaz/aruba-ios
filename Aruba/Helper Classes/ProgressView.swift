//
//  ProgressView.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/14/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

class ProgressView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        self.backgroundColor = Colors.ButtonGreen
    }

    @IBInspectable
    var selected: Bool = false {
        didSet {
            if selected {
                self.backgroundColor = Colors.ButtonGreen
            } else {
                self.backgroundColor = Colors.ButtonGray
            }
        }
    }
}
