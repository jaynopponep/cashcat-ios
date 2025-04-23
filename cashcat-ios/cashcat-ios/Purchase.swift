import Foundation

struct Purchase: Codable {
    let id: UUID
    var name: String
    var amount: Double
    var date: Date
    
    init(id: UUID = UUID(), name: String, amount: Double, date: Date = Date()) {
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date
    }
}
