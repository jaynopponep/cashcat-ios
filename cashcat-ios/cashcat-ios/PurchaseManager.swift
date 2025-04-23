import Foundation
class PurchaseManager {
    static let shared = PurchaseManager()
    
    private let purchasesKey = "purchases"
    
    func getAllPurchases() -> [Purchase] {
        if let data = UserDefaults.standard.data(forKey: purchasesKey),
           let purchases = try? JSONDecoder().decode([Purchase].self, from: data) {
            return purchases
        }
        return []
    }
    
    func addPurchase(_ purchase: Purchase) {
        var purchases = getAllPurchases()
        purchases.append(purchase)
        savePurchases(purchases)
    }
    
    func updatePurchase(_ purchase: Purchase) {
        var purchases = getAllPurchases()
        if let index = purchases.firstIndex(where: { $0.id == purchase.id }) {
            purchases[index] = purchase
            savePurchases(purchases)
        }
    }
    
    func deletePurchase(id: UUID) {
        var purchases = getAllPurchases()
        purchases.removeAll { $0.id == id }
        savePurchases(purchases)
    }
    
    private func savePurchases(_ purchases: [Purchase]) {
        if let data = try? JSONEncoder().encode(purchases) {
            UserDefaults.standard.set(data, forKey: purchasesKey)
        }
    }
    
    func getTotalForCurrentMonth() -> Double {
        let purchases = getAllPurchases()
        let calendar = Calendar.current
        
        let filteredPurchases = purchases.filter { purchase in
            let purchaseComponents = calendar.dateComponents([.year, .month], from: purchase.date)
            let currentComponents = calendar.dateComponents([.year, .month], from: Date())
            
            return purchaseComponents.year == currentComponents.year &&
                   purchaseComponents.month == currentComponents.month
        }
        
        return filteredPurchases.reduce(0) { $0 + $1.amount }
    }
}
