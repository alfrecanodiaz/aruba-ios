//
//  FilterProfessionalResponse.swift
//  Aruba
//
//  Created by Javier Rivarola on 12/9/19.
//  Copyright © 2019 Javier Rivarola. All rights reserved.
//

import Foundation

struct FilterProfessionalResponse: Codable {
    let success: Bool
    let data: [Professional]
}

struct Professional: Codable {
    let id: Int
    let reviewsWithCommentsCount: Int
    let firstName, lastName, email, emailVerifiedAt: String
    let facebookID: String?
    let enabled: Bool?
    let deletedAt: String?
    let createdAt, updatedAt: String
    let canMakeAppointment: Bool?
    let birthdate, document: String?
    let avatarURL: String?
    let averageReviews: Double?
    var servicesCount, likes, salesThisMonth: Int?
    let arubaSalesThisMonth: Int?
    let categories: [ServiceCategory]?
    let appointments: [Appointment]?
    
    mutating func like(_ like: Bool) {
        if like {
            if likes != nil {
                likes! += 1
            }
        } else {
            if likes != nil {
                likes! -= 1
            }
        }
    }
    
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
        case averageReviews = "average_reviews"
        case servicesCount = "services_count"
        case likes
        case salesThisMonth = "sales_this_month"
        case arubaSalesThisMonth = "aruba_sales_this_month"
        case categories, appointments
        case reviewsWithCommentsCount = "reviews_with_comments_count"
    }
}

struct Appointment: Codable {
    
    let id, userAppointerID, userAppointeeID: Int
    let clientName: String
    let addressID: Int
    let fullAddress: String
    let lat, lng: Double
    let price, duration, hourStart, hourEnd: Int
    let date, createdAt, updatedAt: String
    let currentStateID: Int
    let hourStartPretty, hourEndPretty: String
    let currentState: CurrentState
    let paymentMethod: String
    let professionalEarnings: Int
    let clientPhoneNumber: String?
    let services: [Service]?
    let transaction: Transaction
    let client: Client
    let professional: Professional?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userAppointerID = "user_appointer_id"
        case userAppointeeID = "user_appointee_id"
        case clientName = "client_name"
        case addressID = "address_id"
        case fullAddress = "full_address"
        case lat, lng, price, duration
        case hourStart = "hour_start"
        case hourEnd = "hour_end"
        case date
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case currentStateID = "current_state_id"
        case hourStartPretty = "hour_start_pretty"
        case hourEndPretty = "hour_end_pretty"
        case currentState = "current_state"
        case paymentMethod = "payment_method"
        case professionalEarnings = "professional_earnings"
        case clientPhoneNumber = "client_phone_number"
        case services, transaction, client, professional
    }
}

struct Client: Codable {
    let id: Int
    let firstName, lastName, email: String
    let emailVerifiedAt, facebookID: String?
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

struct CurrentState: Codable {
    let id: Int
    let name, displayName: String
    let deletedAt: String?
    let createdAt, updatedAt: String?
    let pivot: CurrentStatePivot
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pivot
    }
}

struct CurrentStatePivot: Codable {
    let appointmentID, appointmentStateID: Int
    let createdAt: String
    let reason: String?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case appointmentID = "appointment_id"
        case appointmentStateID = "appointment_state_id"
        case createdAt = "created_at"
        case reason
        case updatedAt = "updated_at"
    }
}

struct Transaction: Codable {
    let id, appointmentID, transactionableID: Int
    let transactionableType, createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case appointmentID = "appointment_id"
        case transactionableID = "transactionable_id"
        case transactionableType = "transactionable_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    func readableTransactionType() -> String {
        if transactionableType == "App\\BankTransferPaymentGateway" {
            return "Transferencia Bancaria"
        } else if transactionableType == "App\\CardPaymentGateway" {
            return "Tarjeta"
        }
        return ""
    }
}


struct CategoryPivot: Codable {
    let userID, serviceCategoryID: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case serviceCategoryID = "service_category_id"
    }
}

// MARK: Convenience initializers

extension FilterProfessionalResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(FilterProfessionalResponse.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Professional {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Professional.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Appointment {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Appointment.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Client {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Client.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension CurrentState {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(CurrentState.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension CurrentStatePivot {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(CurrentStatePivot.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Transaction {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Transaction.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}


extension CategoryPivot {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(CategoryPivot.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

