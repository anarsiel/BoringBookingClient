//
//  User.swift
//  BoringBookingClient
//
//  Created by Blagoi on 02.12.2021.
//

import Foundation

final class User: Codable {

    var id: String?
    
    var login: String
    
    var password: String
        
    init(id: String, login: String, password: String) {
        self.id = id
        self.login = login
        self.password = password
    }
    
}
