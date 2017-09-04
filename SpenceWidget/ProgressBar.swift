//
//  ProgressBar.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    
    private let fromColor: UIColor = .green
    private let toColor: UIColor = .red
    
    var bar: UIView!
    var barWidthConstraint: NSLayoutConstraint!
    var progress: Float = 0 {
        didSet {
            removeConstraint(barWidthConstraint)
            barWidthConstraint = widthConstraint(multiplier: CGFloat(progress))
            addConstraint(barWidthConstraint)
            bar.backgroundColor = fromColor.transition(to: toColor, progress: CGFloat(progress))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    func construct() {
        layer.cornerRadius = 8
        layer.masksToBounds = false
        clipsToBounds = true
        bar = UIView()
        bar.backgroundColor = fromColor
        let leading = constraintToSelf(view: bar, attribute: .leading)
        let top = constraintToSelf(view: bar, attribute: .top)
        let bottom = constraintToSelf(view: bar, attribute: .bottom)
        barWidthConstraint = widthConstraint(multiplier: 0)
        addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([leading, top, bottom, barWidthConstraint])
    }
    
    private func widthConstraint(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: bar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: multiplier, constant: 0)
    }
    
    private func constraintToSelf(view: UIView, attribute: NSLayoutAttribute, constant: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1, constant: constant)
    }
    
}
