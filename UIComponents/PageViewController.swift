//
//  PageController.swift
//  UIComponents
//
//  Created by Milad on 7/5/24.
//

import UIKit

public class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageControl = UIPageControl()
    var nextPageButton = UIButton()
    var previousPageButton = UIButton()

    // MARK: UIPageViewControllerDataSource

    public lazy var orderedViewControllers: [UIViewController] = {
        return [RedViewController(), BlueViewController()]
    }()
    
    public required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        // Disable user interaction on the scroll view to prevent gesture-based navigation
        for view in self.view.subviews {
            if let subview = view as? UIScrollView {
                subview.isScrollEnabled = false
            }
        }

        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()
        configureNextPageButton()
        configurePreviousPageButton()
        
        // Do any additional setup after loading the view.
    }

    func configurePageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1.0)
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        self.pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)

        // Add constraints for the pageControl
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func configureNextPageButton() {
        nextPageButton.translatesAutoresizingMaskIntoConstraints = false
        let bundle = Bundle(for: PageViewController.self)
        let image = UIImage(named: "Arrow-Right", in: bundle, with: nil)
        nextPageButton.setImage(image, for: .normal)
        nextPageButton.addTarget(self, action: #selector(goToNextPage(_:)), for: .touchUpInside)
        self.view.addSubview(nextPageButton)

        // Add constraints for the nextPageButton
        NSLayoutConstraint.activate([
            nextPageButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            nextPageButton.leadingAnchor.constraint(equalTo: pageControl.trailingAnchor, constant: 8),
            nextPageButton.widthAnchor.constraint(equalToConstant: 24),
            nextPageButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configurePreviousPageButton() {
        previousPageButton.translatesAutoresizingMaskIntoConstraints = false
        let bundle = Bundle(for: PageViewController.self)
        let image = UIImage(named: "Arrow-Left", in: bundle, with: nil)
        previousPageButton.setImage(image, for: .normal)
        previousPageButton.addTarget(self, action: #selector(goToPreviousPage(_:)), for: .touchUpInside)
        self.view.addSubview(previousPageButton)

        // Add constraints for the previousPageButton
        NSLayoutConstraint.activate([
            previousPageButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            previousPageButton.trailingAnchor.constraint(equalTo: pageControl.leadingAnchor, constant: -8),
            previousPageButton.widthAnchor.constraint(equalToConstant: 24),
            previousPageButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: Delegate methods
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let pageContentViewController = pageViewController.viewControllers?.first {
                self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController) ?? 0
            }
        }
    }

    // MARK: Data source functions
   
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    

    @IBAction func goToPreviousPage(_ sender: UIButton) {
        if let currentViewController = viewControllers?.first,
           let previousViewController = orderedViewControllers.firstIndex(of: currentViewController).flatMap({ orderedViewControllers[safe: $0 - 1] }) {
            setViewControllers([previousViewController], direction: .reverse, animated: true) { completed in
                if completed {
                    self.pageControl.currentPage = self.orderedViewControllers.firstIndex(of: previousViewController) ?? 0
                }
            }
        }
    }
    
    @IBAction func goToNextPage(_ sender: UIButton) {
        if let currentViewController = viewControllers?.first,
           let nextViewController = orderedViewControllers.firstIndex(of: currentViewController).flatMap({ orderedViewControllers[safe: $0 + 1] }) {
            setViewControllers([nextViewController], direction: .forward, animated: true) { completed in
                if completed {
                    self.pageControl.currentPage = self.orderedViewControllers.firstIndex(of: nextViewController) ?? 0
                }
            }
        }
    }
}

// Safe subscript extension to handle out of bounds gracefully
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class RedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}

class BlueViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
}
