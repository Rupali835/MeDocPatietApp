//
//  PageViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 13/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController , UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    lazy var orderedViewControllers: [UIViewController] = {
        return [
          //  self.newVc(viewController: "GetStartedViewController"),
            self.newVc(viewController: "LoginPage"),
            self.newVc(viewController: "RegisterViewController")
               ]
    }()
    var pageControl = UIPageControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        configurePageControl()
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.green
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.pageControl.hidesForSinglePage = true
       // self.view.addSubview(pageControl)
    }
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 5.0, initialSpringVelocity: 5.0, options: .transitionFlipFromRight, animations: {
            let pageContentViewController = pageViewController.viewControllers![0]
            self.pageControl.currentPage = self.orderedViewControllers.index(of: pageContentViewController)!
            self.pageControl.hidesForSinglePage = true
        }, completion: nil)
        
    }
    func nextPageWithIndex(index: Int) {
        setViewControllers([orderedViewControllers[index]], direction: .forward, animated: true, completion: nil)
    }
    func PreviousPageWithIndex(index: Int) {
        setViewControllers([orderedViewControllers[index]], direction: .reverse, animated: true, completion: nil)
    }
}
