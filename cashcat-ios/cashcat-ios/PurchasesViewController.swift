import UIKit

class PurchasesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private var purchases: [(name: String, amount: String)] = [
        ("Gas", "$29.99"),
        ("Groceries", "$16.49"),
        ("Disney+ Subscription", "$10.99")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up view
        view.backgroundColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 30))
        titleLabel.text = "List of Purchases"
        titleLabel.textColor = .gray
        view.addSubview(titleLabel)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PurchaseCell")
        
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath)
        
        let purchase = purchases[indexPath.row]
        cell.textLabel?.text = purchase.title
        cell.detailTextLabel?.text = purchase.amount
        
        cell.accessoryType = .disclosureIndicator
        
        cell = UITableViewCell(style: .value1, reuseIdentifier: "PurchaseCell")
        cell.textLabel?.text = purchase.title
        cell.detailTextLabel?.text = purchase.amount
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
