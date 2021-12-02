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
