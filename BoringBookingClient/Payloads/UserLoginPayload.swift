//
//  UserLoginPayload.swift
//  BoringBookingClient
//
//  Created by Благой Димитров on 28.12.2021.
//

import Foundation

final class UserLoginPayload: Codable {
    var login: String
    var password: String
}
