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

    init(address: AddressViewModel) {
        let attr = NSMutableAttributedString()
        // TODO: Uncomment
//        let name = NSAttributedString(string: address.name + ": ", attributes: [.font: UIFont(name: "Lato-Bold", size: 12)!])
//        let addr = NSAttributedString(string: address.street1 + ", " + address.houseNumber + ", " + address.street2, attributes: [.font: UIFont(name: "Lato-Regular", size: 12)!])
//        attr.append(name)
//        attr.append(addr)
        attributedDataString = attr
    }

    init(title: String, content: String) {
        let attr = NSMutableAttributedString()
        let title = NSAttributedString(string: title + ": ", attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        let content = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 12)])
        attr.append(title)
        attr.append(content)
        attributedDataString = attr
    }

}
