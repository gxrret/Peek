//
//  Onboarding.swift
//  Peek
//
//  Created by Garret Koontz on 3/6/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class Onboarding: UIViewController {
    var pageViewController: UIPageViewController!
    static var pageIndex = 0
    static let pages = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController?.setViewControllers([Tutorial.initializeFromStoryboard()], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPageViewController" {
            pageViewController = segue.destination as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
        }
    }
}

extension Onboarding: UIPageViewControllerDelegate {
    
}

extension Onboarding: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vcBefore = viewController as! Tutorial
        switch vcBefore.pageIndex {
        case 0:
            return nil
        case 1:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 0
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
        case 2:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 1
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
        case 3:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 2
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
        case 4:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 3
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
        default:
            break
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vcAfter = viewController as! Tutorial
        switch vcAfter.pageIndex {
        case 0:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 1
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
        case 1:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 2
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
        case 2:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 3
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
        case 3:
            let tutorialPage = Tutorial.initializeFromStoryboard()
            Onboarding.pageIndex = 4
            tutorialPage.pageIndex = Onboarding.pageIndex
            return tutorialPage
//        case 4:
//            let tutorialPage = Tutorial.initializeFromStoryboard()
//            Onboarding.pageIndex = 5
//            tutorialPage.pageIndex = Onboarding.pageIndex
//            return tutorialPage
        case 4:
            UserDefaults.standard.set(true, forKey: "onboarding")
            presentingViewController?.dismiss(animated: true, completion: nil)
        default:
            break
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .white
        appearance.currentPageIndicatorTintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        appearance.isOpaque = true
        appearance.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        return Onboarding.pages
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return Onboarding.pageIndex
    }
}
