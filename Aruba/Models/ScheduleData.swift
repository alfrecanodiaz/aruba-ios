//
//  ScheduleData.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/21/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
struct ScheduleData {
    let persons: [Person]

    func totalPriceString() -> String? {
        var total: Double = 0

        for person in self.persons {
            for product in person.scheduleProducts {
                total += product.price
            }
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_PY")
        return formatter.string(from: NSNumber(value: total))
    }
}
