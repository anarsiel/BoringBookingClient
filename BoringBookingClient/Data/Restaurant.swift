//
//  Restaurant.swift
//  BoringBookingClient
//
//  Created by Blagoi on 29.11.2021.
//

import Foundation

struct Restaurant: Codable {
    var id: String
    var name: String?
    
    init() {
        id = ""
        name = ""
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct Restaurants: Codable {
    var results: [Restaurant]
}
