//
//  GenericDataCellViewModel.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/6/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

class GenericDataCellViewModel {

    var attributedDataString: NSAttributedString
    var index: Int
    
    init(address: AddressViewModel, index: Int) {
        let attr = NSMutableAttributedString()
        if address.isDefault {
            let isDefault = NSAttributedString(string: "Por defecto - ", attributes: [.font: UIFont(name: "Lato-Bold", size: 13)!])
            attr.append(isDefault)
        }
        let name = NSAttributedString(string: address.name + ": ", attributes: [.font: UIFont(name: "Lato-Bold", size: 13)!])
        let addr = NSAttributedString(string: address.street1 + ", " + address.houseNumber + ", " + address.street2, attributes: [.font: UIFont(name: "Lato-Regular", size: 12)!])
        attr.append(name)
        attr.append(addr)
        attributedDataString = attr
        self.index = index
    }

    init(title: String, content: String, index: Int) {
        let attr = NSMutableAttributedString()
        let title = NSAttributedString(string: title + ": ", attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        let content = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 12)])
        attr.append(title)
        attr.append(content)
        attributedDataString = attr
        self.index = index
    }

}
