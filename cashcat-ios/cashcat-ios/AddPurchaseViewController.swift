import UIKit

class AddPurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Properties
    private var tableView: UITableView!
    private var purchases: [Purchase] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Purchase"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        purchases = [
            Purchase(name: "", amount: 0.0)
        ]
        
        setupUI()
        setupTableView()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseCell.self, forCellReuseIdentifier: "PurchaseCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        tableView.tableFooterView = footerView
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        purchases.append(Purchase(name: "", amount: 0.0))
        tableView.reloadData()
    }
    
    @objc private func doneTapped() {
        for purchase in purchases {
            if !purchase.name.isEmpty && purchase.amount > 0 {
                PurchaseManager.shared.addPurchase(purchase)
            }
        }
        
        dismiss(animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath) as! PurchaseCell
        let purchase = purchases[indexPath.row]
        
        cell.configure(name: purchase.name, amount: String(format: "$%.2f", purchase.amount))
        cell.nameTextField.delegate = self
        cell.amountTextField.delegate = self
        cell.nameTextField.tag = indexPath.row * 2
        cell.amountTextField.tag = indexPath.row * 2 + 1
        
        // Show delete button for all rows
        cell.showDeleteButton(true)
        cell.deleteButtonAction = { [weak self] in
            self?.deletePurchase(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func deletePurchase(at indexPath: IndexPath) {
        purchases.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let row = textField.tag / 2
        let isAmountField = textField.tag % 2 == 1
        
        if row < purchases.count {
            var purchase = purchases[row]
            
            if isAmountField {
                if let text = textField.text?.replacingOccurrences(of: "$", with: ""),
                   let amount = Double(text) {
                    purchase.amount = amount
                    textField.text = String(format: "$%.2f", amount)
                }
            } else {
                purchase.name = textField.text ?? ""
            }
            
            purchases[row] = purchase
        }
    }
}
