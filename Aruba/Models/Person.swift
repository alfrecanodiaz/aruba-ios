//
//  Person.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/21/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation
import UIKit

struct Person: Equatable {

    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }

    let gender: Gender
    var scheduleProducts: [Product] = []
    var scheduleDate: ScheduleDate?
    var index: Int = 1
    var id: String

    enum Gender: String {
        case women = "MUJER", children = "NIÑO", man = "HOMBRE"

        var image: UIImage {
            switch self {
            case .women:
                return #imageLiteral(resourceName: "women")
            case .children:
                return #imageLiteral(resourceName: "women")
            case .man:
                return #imageLiteral(resourceName: "women")
            }
        }
    }

    init(gender: Gender, index: Int) {
        self.gender = gender
        self.index = index
        self.id = String().generateID()
    }

}
