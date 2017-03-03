//
//  RandomColor.swift
//  Peek
//
//  Created by Garret Koontz on 3/3/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class RandomColor {
    
    static func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

    }
}
