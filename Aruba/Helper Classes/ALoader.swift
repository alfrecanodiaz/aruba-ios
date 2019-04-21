//
//  ALoader.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/21/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import SVProgressHUD

class ALoader {
    class func show() {
        if SVProgressHUD.isVisible() {
            print("Already showing a svprogresshud")
            return
        }
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }

    class func hide() {
        SVProgressHUD.dismiss()
    }
}
