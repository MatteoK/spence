//
//  Extensions.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

extension UIColor {
    
    func transition(to color: UIColor, progress: CGFloat) -> UIColor {
        let red = map(from: self.redValue, to: color.redValue, progress: progress)
        let green = map(from: self.greenValue, to: color.greenValue, progress: progress)
        let blue = map(from: self.blueValue, to: color.blueValue, progress: progress)
        let alpha = map(from: self.alphaValue, to: color.alphaValue, progress: progress)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func map(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
        let delta = to - from
        return from + delta * progress
    }
    
    var redValue: CGFloat {
        return color(at: 0)
    }
    
    var greenValue: CGFloat {
        return color(at: 1)
    }
    
    var blueValue: CGFloat {
        return color(at: 2)
    }
    
    var alphaValue: CGFloat {
        return color(at: 3)
    }
    
    private func color(at index: Int) -> CGFloat {
        guard let colors = cgColor.components,
            colors.count > index else {
                return 0
        }
        return colors[index]
    }
    
}

extension UIColor {
    
    static let backgroundColor = UIColor(red: 56/255.0, green: 65/255.0, blue: 78/255.0, alpha: 1)
    static let darkBackground = UIColor(red: 36/255.0, green: 35/255.0, blue: 48/255.0, alpha: 1)
    static let spenceGreen = UIColor.green
    static let spenceRed = UIColor.red
    static let cta = UIColor(red: 89/255.0, green: 212/255.0, blue: 217/255.0, alpha: 1)
    static let ctaActive = UIColor(red: 69/255.0, green: 192/255.0, blue: 197/255.0, alpha: 1)
    
}
