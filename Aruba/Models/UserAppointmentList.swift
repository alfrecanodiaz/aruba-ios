//
//  UserAppointmentList.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/26/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct UserAppointmentList: Codable {
    let success: Bool
    let data: PaginatedData
}

struct PaginatedData: Codable {
    let currentPage: Int
    let data: [Appointment]
    let firstPageURL: String
    let from, lastPage: Int
    let lastPageURL: String
    let nextPageURL: String?
    let path: String
    let perPage: Int
    let prevPageURL: String?
    let to, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}
