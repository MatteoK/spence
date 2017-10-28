//
//  UIView+Spence.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

extension UIView {
    
    func addExpandedSubview(view: UIView) {
        addSubview(view)
        view.expand(in: self)
    }
    
    func expand(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.equalConstraints(from: view, to: self, attributes: [.leading, .trailing, .top, .bottom]))
    }
    
}
