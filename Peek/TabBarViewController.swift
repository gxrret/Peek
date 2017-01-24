//
//  TabBarViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var firstItemImageView: UIImageView!
    
    var secondItemImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstItemView = self.tabBar.subviews[0]
       
        self.firstItemImageView = firstItemView.subviews.first as! UIImageView
        
        self.firstItemImageView.contentMode = .center
        
        let secondItemView = self.tabBar.subviews[1]
        
        self.secondItemImageView = secondItemView.subviews.first as! UIImageView
        
        self.secondItemImageView.contentMode = .center
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            self.firstItemImageView.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.25, animations: {
                self.firstItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
            
            UIView.animate(withDuration: 0.25, delay: 0.125, options: .curveEaseInOut, animations: {
                self.firstItemImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2.0))
            }, completion: nil)
        }
        
        if item.tag == 2 {
            self.secondItemImageView.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, animations: {
                self.secondItemImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (success) in
                UIView.animate(withDuration: 0.25, delay: 0, animations: {
                    self.secondItemImageView.transform = CGAffineTransform.identity
                })
            })
        }
    }
}
