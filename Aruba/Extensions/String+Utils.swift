//
//  String+Utils.swift
//  Aruba
//
//  Created by Javier Rivarola on 4/21/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

extension String {
    
    func generateID() -> String {
        let length: Int = 10
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    var integer: Int {
        return Int(self) ?? 0
    }
    
    var secondFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        let seconds = components[2].integer
        return Int((hours * 60 * 60) + (minutes * 60) + seconds)
    }
}
