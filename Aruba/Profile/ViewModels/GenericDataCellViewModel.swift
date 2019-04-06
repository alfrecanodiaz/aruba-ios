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
    
    init(address: Address) {
        let attr = NSMutableAttributedString()
        let name = NSAttributedString(string: address.name + ": ", attributes: [.font : UIFont.boldSystemFont(ofSize: 12)])
        let addr = NSAttributedString(string: address.street1 + ", " + address.houseNumber + ", " + address.street2, attributes: [.font : UIFont.systemFont(ofSize: 12)])
        attr.append(name)
        attr.append(addr)
        attributedDataString = attr
    }
    
}
