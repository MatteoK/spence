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
        view.expand(in: self, insets: insets)
    }
    
    func expand(in view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            .equalConstraint(from: view, to: self, attribute: .leading, constant: insets.left),
            .equalConstraint(from: view, to: self, attribute: .top, constant: -insets.top),
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

extension UIView {
    
    enum LinePosition {
        case top
        case bottom
    }
    
    func addLine(color: UIColor, position: LinePosition) {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = color
        addSubview(line)
        addConstraints([
            .equalConstraint(from: line, to: self, attribute: .leading),
            .equalConstraint(from: line, to: self, attribute: .trailing),
            .absoluteConstraint(view: line, attribute: .height, constant: 1),
            position == .top ?
                .equalConstraint(from: line, to: self, attribute: .top) :
                .equalConstraint(from: line, to: self, attribute: .bottom)
        ])
    }
    
}
