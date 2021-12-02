//
//  Reservation.swift
//  BoringBookingClient
//
//  Created by Blagoi on 02.12.2021.
//

import Foundation

final class Reservation: Codable {
    
    var id: String
    
    var restaurant: Restaurant
    
    var table: Table
    
    var user: User
    
    var startTimestamp: String
    
    var endTimestamp: String
    
    var comment: String?
        
    init(
        id: String,
        restaurant: Restaurant,
        table: Table,
        user: User,
        startTimestamp: String,
        endTimestamp: String,
        comment: String? = nil
    ) {
        self.id = id
        self.restaurant = restaurant
        self.table = table
        self.user = user
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.comment = comment
    }
}
