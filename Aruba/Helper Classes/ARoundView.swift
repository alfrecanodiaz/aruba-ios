//
//  ARoundView.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/9/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

class ARoundView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.width/2
        clipsToBounds = true
    }

}
