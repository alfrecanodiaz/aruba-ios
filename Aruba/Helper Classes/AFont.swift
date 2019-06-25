//
//  AFont.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/26/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

class AFont {

    enum Weight {
        case bold, black, regular
    }

    static func with(size: CGFloat, weight: Weight) -> UIFont {
        var font: UIFont!
        switch weight {
        case .bold:
            font = UIFont(name: "Lato-Bold", size: size)!
        case .black:
            font = UIFont(name: "Lato-Black", size: size)!
        case .regular:
            font = UIFont(name: "Lato-Regular", size: size)!
        }
        return font
    }
}
