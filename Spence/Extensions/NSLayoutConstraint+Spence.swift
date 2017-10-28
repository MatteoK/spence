//
//  Foo.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    static func equalConstraint(from: UIView, to: UIView, attribute: NSLayoutAttribute, constant: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: from, attribute: attribute, relatedBy: .equal, toItem: to, attribute: attribute, multiplier: 1, constant: constant)
    }
    
    static func equalConstraints(from: UIView, to: UIView, attributes: [NSLayoutAttribute], constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return attributes.map({
            let constant = [NSLayoutAttribute.bottom, NSLayoutAttribute.trailing].contains($0) ? -constant : constant
            return self.equalConstraint(from: from, to: to, attribute: $0, constant: constant)
        })
    }
    
}
