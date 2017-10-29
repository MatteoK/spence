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
    private var progress: Float = 0 {
        didSet {
            removeConstraint(barWidthConstraint)
            barWidthConstraint = widthConstraint(multiplier: CGFloat(progress))
            addConstraint(barWidthConstraint)
            bar.backgroundColor = .progressColor(value: CGFloat(progress))
        }
    }
    
    func updateProgress(value: Float) {
        let newProgress = min(max(value, 0), 1)
        progress = newProgress
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
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        addBar()
    }
    
    private func addBar() {
        bar = UIView()
        let leading = constraintToSelf(view: bar, attribute: .leading, constant: 1)
        let top = constraintToSelf(view: bar, attribute: .top, constant: 1)
        let bottom = constraintToSelf(view: bar, attribute: .bottom, constant: -1)
        barWidthConstraint = widthConstraint(multiplier: 0)
        addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([leading, top, bottom, barWidthConstraint])
        bar.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        bar.layer.shadowOpacity = 1
        bar.layer.shadowRadius = 2
        bar.layer.shadowOffset = CGSize.zero
    }
    
    private func widthConstraint(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: bar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: multiplier, constant: -2)
    }
    
    private func constraintToSelf(view: UIView, attribute: NSLayoutAttribute, constant: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1, constant: constant)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        bar.layer.cornerRadius = bar.frame.height/2
    }
    
}
