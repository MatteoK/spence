//
//  QueueIndicatorView.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class QueueIndicatorView: UIView {
    
    private var _progress: CGFloat = 0
    var progress: CGFloat {
        set {
            let value = newValue > 1 ? 1 : newValue < 0 ? 0 : newValue
            _progress = value
            circleShape.strokeEnd = value
            circleShape.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).transition(to: UIColor.green, progress: value).cgColor
        }
        get {
            return _progress
        }
    }
    private var circleShape: CAShapeLayer!
    private let padding: CGFloat = 5
    private var plusLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    private func construct() {
        addCircle()
        addPlus()
    }
    
    private func addCircle() {
        // round view
        let roundView = UIView(frame: CGRect(x:padding, y:padding, width: frame.width-padding*2, height: frame.height-padding*2))
        roundView.layer.cornerRadius = roundView.frame.size.width / 2
        
        // bezier path
        let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
                                      radius: roundView.frame.size.width / 2,
                                      startAngle: CGFloat(-0.5 * .pi),
                                      endAngle: CGFloat(1.5 * .pi),
                                      clockwise: true)
        // circle shape
        circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.strokeColor = UIColor.black.cgColor
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 1
        // set start and end values
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = progress
        
        // add sublayer
        roundView.layer.addSublayer(circleShape)
        // add subview
        addSubview(roundView)
    }
    
    private func addPlus() {
        plusLabel = UILabel()
        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        plusLabel.text = "+"
        plusLabel.alpha = 0
        plusLabel.textColor = UIColor.green
        addSubview(plusLabel)
        addConstraint(NSLayoutConstraint(item: plusLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: plusLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -1))
    }
    
    func performFinishAnimation() {
        performZoomIn { [weak self] in
            self?.performZoomOut {
                self?.reset()
            }
        }
    }
    
    private func reset() {
        self.plusLabel.alpha = 0
        self.progress = 0
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] timer in
            self?.alpha = 1
        })
    }
    
    private func performZoomIn(completion: @escaping ()->Void) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.plusLabel.alpha = 1
            self?.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        }) { _ in
            completion()
        }
    }
    
    private func performZoomOut(completion: @escaping ()->Void) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 0
            self?.transform = CGAffineTransform.identity
        }) { _ in
            completion()
        }
    }
    
    func performCancelAnimation() {
        UIView.animate(
            withDuration: 0.4,
            animations: { [weak self] in
                self?.progress = 0
                self?.alpha = 0
            },
            completion: { [weak self] _ in
                self?.reset()
            }
        )
    }
    
}
