//
//  UIView+Spence.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

extension UIView {
    
    func addExpandedSubview(view: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(view)
        view.expand(in: self)
    }
    
    func expand(in view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            .equalConstraint(from: view, to: self, attribute: .leading, constant: insets.left),
            .equalConstraint(from: view, to: self, attribute: .top, constant: insets.top),
            .equalConstraint(from: view, to: self, attribute: .trailing, constant: insets.right),
            .equalConstraint(from: view, to: self, attribute: .bottom, constant: insets.bottom)
        ])
    }
    
}

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    fileprivate static var nibName: String {
        return String(describing: self)
    }
    
}

extension UIView {
    
    static var fromNib: UIView? {
        return Bundle.main.loadNibNamed(self.nibName, owner: nil, options: nil)?.first as? UIView
    }
    
}
