//
//  CreateAppointmentResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/16/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct CreateAppointmentResponse: Codable {
    let success: Bool
    let data: Appointment
}
