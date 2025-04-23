import UIKit

class AddPurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private var tableView: UITableView!
    private var purchases: [(name: String, amount: String)] = [
        ("Gas", "$29.00"),
        ("Groceries", "$16.49")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        let titleLabel = UILabel()
        titleLabel.text = "Add Purchase"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .black
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let divider = UIView()
        divider.backgroundColor = .systemGray5
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseCell.self, forCellReuseIdentifier: "PurchaseCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
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
    
    @objc private func addButtonTapped() {
        purchases.append(("New Item", "$0.00"))
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath) as! PurchaseCell
        let purchase = purchases[indexPath.row]
        
        cell.configure(name: purchase.name, amount: purchase.amount)
        cell.nameTextField.delegate = self
        cell.amountTextField.delegate = self
        cell.nameTextField.tag = indexPath.row * 2
        cell.amountTextField.tag = indexPath.row * 2 + 1
        
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
                if let text = textField.text, !text.isEmpty {
                    if !text.hasPrefix("$") {
                        textField.text = "$\(text)"
                    }
                    purchase.amount = textField.text ?? "$0.00"
                }
            } else {
                purchase.name = textField.text ?? "Item"
            }
            
            purchases[row] = purchase
        }
    }
}

class PurchaseCell: UITableViewCell {
    
    let nameTextField = UITextField()
    let amountTextField = UITextField()
    private let deleteButton = UIButton(type: .system)
    
    var deleteButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemGroupedBackground
        
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        nameTextField.placeholder = "Item name"
        contentView.addSubview(nameTextField)
        
        amountTextField.font = UIFont.systemFont(ofSize: 16)
        amountTextField.placeholder = "$0.00"
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .right
        contentView.addSubview(amountTextField)
        
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .systemGray3
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        contentView.addSubview(deleteButton)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            amountTextField.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 10),
            amountTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(name: String, amount: String) {
        nameTextField.text = name
        amountTextField.text = amount
    }
    
    func showDeleteButton(_ show: Bool) {
        deleteButton.isHidden = !show
    }
    
    @objc private func deleteButtonTapped() {
        deleteButtonAction?()
    }
}
