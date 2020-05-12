//
//  LoggerManager.swift
//  Aruba
//
//  Created by Javier Rivarola on 5/12/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FacebookCore

protocol Logger {
    static func log(event: [String: Any])
}

enum FacebookLogger: Logger {
    
    static func log(event: [String: Any]) {
        AppEvents.logEvent(AppEvents.Name.purchased);
    }
}
