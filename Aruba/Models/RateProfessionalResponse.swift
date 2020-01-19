//
//  RateProfessionalResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 1/8/20.
//  Copyright © 2020 Javier Rivarola. All rights reserved.
//

import Foundation

struct RateProfessionalResponse: Codable {
    let success: Bool
    let data: RatingData
}

struct RatingData: Codable {
    let ratingNumber: Int
    let text: String
    let userID, reviewerID: Int
    let updatedAt, createdAt: String
    let id: Int
    let liked: Bool
    let reviewer: Reviewer

    enum CodingKeys: String, CodingKey {
        case ratingNumber = "rating_number"
        case text
        case userID = "user_id"
        case reviewerID = "reviewer_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id, liked, reviewer
    }
}

struct Reviewer: Codable {
    let id: Int
    let firstName, lastName, email: String
    let emailVerifiedAt: String?
    let facebookID: String
    let enabled: Bool
    let deletedAt: String?
    let createdAt, updatedAt: String
    let canMakeAppointment: Bool
    let birthdate, document: String?
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case emailVerifiedAt = "email_verified_at"
        case facebookID = "facebook_id"
        case enabled
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case canMakeAppointment = "can_make_appointment"
        case birthdate, document
        case avatarURL = "avatar_url"
    }
}

