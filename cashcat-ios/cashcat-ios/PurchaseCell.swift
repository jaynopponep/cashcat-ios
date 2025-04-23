import UIKit

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
    
    // MARK: - UI Setup
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
    
    // MARK: - Actions
    @objc private func deleteButtonTapped() {
        deleteButtonAction?()
    }
}
