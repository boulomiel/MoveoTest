//
//  AuthPageViewController.swift
//  tabsandpage
//
//  Created by Ruben Mimoun on 11/11/2021.
//

import Foundation
import UIKit

protocol AuthPageStoryboard {}

class AuthPageviewController : UIPageViewController, AuthPageStoryboard{
    
    lazy var pagesControlled : [UIViewController] = {
        let login : LoginViewController =  LoginViewController.instantiate()
        let register : RegisterViewController =  RegisterViewController.instantiate()
        return [login, register]
    }()
    
    lazy var pageControl : UIPageControl={
        var pageControl = UIPageControl(frame: CGRect(x: 0,y: 100,width: UIScreen.main.bounds.width,height: 50))
        return pageControl
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false )
        self.dataSource = self
        self.delegate = self
        configurePageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewControllers([pagesControlled[0]], direction: .forward, animated: true, completion: nil)
    }
    
    private func configurePageControl(){
        pageControl.numberOfPages = pagesControlled.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.purple
        colorFading()
        self.view.addSubview(pageControl)
    }
    
    private func handlePageControl(currentViewController : UIViewController){
        if let index = pagesControlled.firstIndex(of: currentViewController){
            pageControl.currentPage = index
        }
    }
    
    private func colorFading(){
        UIView.animate(withDuration: 0.7) {[weak self] in
            guard let self = self else {return}
            if self.pageControl.currentPageIndicatorTintColor == .purple{
                self.pageControl.currentPageIndicatorTintColor = .white
            }else{
                self.pageControl.currentPageIndicatorTintColor = .purple
            }
        }completion: {[weak self] _ in
            self?.colorFading()
        }
    }
}

extension AuthPageviewController :  UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let current =  pagesControlled.firstIndex(of: viewController)!
        if current == 0 {
            return nil
        }else{
            return  pagesControlled[current - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let max =  pagesControlled.count - 1
        let current =  pagesControlled.firstIndex(of: viewController)!
        if current == max {
            return nil
        }else{
            return pagesControlled[current + 1 ]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let controllers = pageViewController.viewControllers{
            handlePageControl(currentViewController: controllers[0])
        }
    }
}


