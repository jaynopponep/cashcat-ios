import UIKit

class HomeViewController: UIViewController {
    
    private var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let safeAreaTop = self.view.safeAreaInsets.top > 0 ? self.view.safeAreaInsets.top : 44
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: safeAreaTop + 10, width: view.frame.width, height: 30))
        titleLabel.text = "Cash Cat"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .gray
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(titleLabel)
        
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        circleView.backgroundColor = UIColor(
            red: 33/255,
            green: 222/255,
            blue: 255/255,
            alpha: 1.0
        )
        circleView.layer.cornerRadius = 100
        circleView.center = view.center
        view.addSubview(circleView)
        
        balanceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        balanceLabel.center = CGPoint(x: circleView.bounds.width/2, y: circleView.bounds.height/2 - 15)
        circleView.addSubview(balanceLabel)
        
        let monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 30))
        monthLabel.text = "this month"
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.systemFont(ofSize: 16)
        monthLabel.center = CGPoint(x: circleView.bounds.width/2, y: circleView.bounds.height/2 + 15)
        circleView.addSubview(monthLabel)
        
        let addPurchaseButton = UIButton(type: .system)
        addPurchaseButton.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        addPurchaseButton.setTitle("Add Purchase", for: .normal)
        addPurchaseButton.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        addPurchaseButton.addTarget(self, action: #selector(addPurchaseButtonTapped), for: .touchUpInside)
        view.addSubview(addPurchaseButton)
        
        updateBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalance()
    }
    
    private func updateBalance() {
        let total = PurchaseManager.shared.getTotalForCurrentMonth()
        balanceLabel.text = String(format: "$%.2f", total)
    }
    
    @objc private func addPurchaseButtonTapped() {
        let addPurchaseVC = AddPurchaseViewController()
        let navController = UINavigationController(rootViewController: addPurchaseVC)
        present(navController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let titleLabel = view.subviews.first(where: { ($0 as? UILabel)?.text == "Cash Cat" }) as? UILabel {
            titleLabel.frame = CGRect(
                x: 0,
                y: view.safeAreaInsets.top + 10,
                width: view.frame.width,
                height: 30
            )
        }
    }
}
