//
//  UIViewController+Spence.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func instantiate<T>(from storyboard: UIStoryboard) -> T {
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier()) as! T
    }
    
    private static func storyboardIdentifier() -> String {
        return String(describing: self)
    }
    
}
