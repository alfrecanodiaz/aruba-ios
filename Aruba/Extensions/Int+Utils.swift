//
//  Int+Utils.swift
//  Aruba
//
//  Created by Javier Rivarola on 2/16/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import Foundation

extension Int {
    /// Convert a seconds int to a human readable hour minute string
    func asHourMinuteString() -> String {
        let hours = Int(floor(Double(self/60/60)))
        let minutes = self/60 - hours*60
        var hoursString: String = "\(hours)"
        var minutesString: String = "\(minutes)"
        if minutes < 10 {
            minutesString = "0\(minutesString)"
        }
        if hours < 10 {
            hoursString = "0\(hoursString)"
        }
        return hoursString + ":" + minutesString
    }
}
