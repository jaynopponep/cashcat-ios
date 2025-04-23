import UIKit

class HomeViewController: UIViewController {
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
        
        let addPurchaseButton = UIButton(type: .system)
        addPurchaseButton.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        addPurchaseButton.setTitle("Add Purchase", for: .normal)
        addPurchaseButton.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        view.addSubview(addPurchaseButton)
    }
}
