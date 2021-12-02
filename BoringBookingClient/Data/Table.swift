import Foundation

final class Table: Codable {
    
    var id: String
    
    var restaurant: Restaurant?
    
    var number: Int32?

    var tableType: TableType?
    
    init(id: String, restaurant: Restaurant, number: Int32, tableType: TableType) {
        self.id = id
        self.restaurant = restaurant
        self.number = number
        self.tableType = tableType
    }
}

final class TableType: Codable {
    var cosy: Bool
    
    var silent: Bool
    
    var nearWindow: Bool
    
    var kitchenView: Bool
    
    init(cosy: Bool = false, silent: Bool = false, nearWindow: Bool = false, kitchenView: Bool = false) {
        self.cosy = cosy
        self.silent = silent
        self.nearWindow = nearWindow
        self.kitchenView = kitchenView
    }
}
