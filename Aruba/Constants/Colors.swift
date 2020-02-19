//
//  Colors.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/5/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import UIKit

enum Colors {
    static let ButtonGreen = UIColor(hexRGB: "79DDCD")!
    static let AlertTintColor = #colorLiteral(red: 0.1764705882, green: 0.5254901961, blue: 0.4745098039, alpha: 1)
    static let alertTitleColor = #colorLiteral(red: 0.337254902, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
    static let alertMessageColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.6666666667, alpha: 1)
    static let ButtonHighlightedGreen = #colorLiteral(red: 0.2903032208, green: 0.5338145648, blue: 0.4986980302, alpha: 1)
    static let ButtonGray = UIColor(hexRGB: "A8A8A8")!
    static let ButtonBrown = UIColor(hexRGB: "C7AF99")!
    static let ButtonDarkGray = UIColor(hexRGB: "363430")!

    //categories
    static let Peluqueria = UIColor(hexRGB: "75AEA8")!
    static let Manicura = UIColor(hexRGB: "78DDCD")!

    static let Estetica = UIColor(hexRGB: "B8A18F")!
    static let Masajes = UIColor(hexRGB: "D5BEAD")!
    static let Nutricion = UIColor(hexRGB: "CCCCCC")!
    static let Barberia = UIColor(hexRGB: "75AEA8")!
    
    enum Greens {
        static let borderLine = #colorLiteral(red: 0.4117647059, green: 0.7647058824, blue: 0.7098039216, alpha: 1)
        static let calendarSelected = #colorLiteral(red: 0.4117647059, green: 0.7647058824, blue: 0.7098039216, alpha: 1)
        static let calendarLabel = #colorLiteral(red: 0.1529411765, green: 0.2392156863, blue: 0.3215686275, alpha: 0.9029214349)
        // #2D8679
        static let professionalListHeader = #colorLiteral(red: 0.1764705882, green: 0.5254901961, blue: 0.4745098039, alpha: 1)
        static let enabledButtonBackground = Greens.professionalListHeader
        // #F0FBFA
        static let lightBackground = #colorLiteral(red: 0.9411764706, green: 0.9843137255, blue: 0.9803921569, alpha: 1)
    }
    
    enum Whites {
        // #F6F8F9
        static let calendarUnselected = #colorLiteral(red: 0.9647058824, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
    }
    
    enum Grays {
        // #4A4A4A
        static let enabledDateText = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        // #9B9B9B
        static let disabledDateText = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        // #9B9B9B opacity 90%
        static let calendarDisabledText = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 0.8976672535)
        // #E8F2F1
        static let disabledButtonBackground = #colorLiteral(red: 0.9098039216, green: 0.9490196078, blue: 0.9450980392, alpha: 1)
        // #979797
        static let disabledButtonText = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    }
}
