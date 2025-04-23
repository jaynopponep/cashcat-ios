import UIKit

class ViewController: UIViewController {
    
    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()
    private var currentIndex = 0
    private var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPages()
        setupPageViewController()
        setupPageControl()
    }
    
    private func setupPages() {
        let homeVC = HomeViewController()
        let purchasesVC = PurchasesViewController()
        
        pages = [homeVC, purchasesVC]
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.bounds
        pageViewController.didMove(toParent: self)
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let current = sender.currentPage
        
        let direction: UIPageViewController.NavigationDirection = current > currentIndex ? .forward : .reverse
        
        currentIndex = current
        
        pageViewController.setViewControllers([pages[currentIndex]], direction: direction, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
            pageControl.currentPage = index
            currentIndex = index
        }
    }
}
