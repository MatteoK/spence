//
//  CircularProgressBar.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

final class CircularProgressBar: UIView {
    
    private var backgroundCircle: CircleView?
    private var progressCircle: CircleView?
    private var circleShape: CAShapeLayer?
    
    var topLabel = UILabel()
    var bottomLabel = UILabel()
    
    private var stroke: CGFloat = 10
    private var progress: CGFloat = 1
    
    func updateProgress(value: CGFloat, animated: Bool) {
        progress = value
        progressCircle?.configure(
            color: .progressColor(value: value),
            progress: value
        )
    }
    
    func configure(backgroundColor: UIColor) {
        backgroundCircle?.configure(color: backgroundColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    private func construct() {
        addBackgroundCircle()
        addProgressCircle()
        addLabels()
        topLabel.text = "55€"
        bottomLabel.text = "of 6"
    }
    
    private func addBackgroundCircle() {
        let circleView = CircleView(frame: .zero)
        circleView.configure(stroke: stroke, shadowColor: .clear, color: .darkGray, shadowRadius: 0)
        addExpandedSubview(view: circleView)
        backgroundCircle = circleView
    }
    
    private func addProgressCircle() {
        let circleView = CircleView(frame: .zero)
        circleView.configure(stroke: stroke, shadowColor: UIColor.black.withAlphaComponent(0.5), color: .blue, shadowRadius: 2)
        addExpandedSubview(view: circleView)
        progressCircle = circleView
    }
    
    private func addLabels() {
        topLabel.textColor = .white
        topLabel.font = UIFont.systemFont(ofSize: 22)
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        bottomLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLabel)
        addSubview(bottomLabel)
        addConstraints([
            NSLayoutConstraint(item: topLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -7),
            NSLayoutConstraint(item: bottomLabel, attribute: .top, relatedBy: .equal, toItem: topLabel, attribute: .bottom, multiplier: 1, constant: 2),
            NSLayoutConstraint(item: bottomLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            ])
    }
    
}

