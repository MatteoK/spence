//
//  CancelButtonCell.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

private let padding: CGFloat = 7
private let stroke: CGFloat = 2

class CancelButtonCell: UICollectionViewCell {

    static let nibName = "CancelButtonCell"
    
    var onButtonPressed: (()->Void)?
    
    @IBOutlet weak var button: UIButton!
    private var circleShape: CAShapeLayer?
    private var roundView: UIView?
    
    private var _progress: CGFloat = 0
    var progress: CGFloat {
        set {
            let value = newValue > 1 ? 1 : newValue < 0 ? 0 : newValue
            _progress = value
            circleShape?.strokeEnd = 1 - value
        }
        get {
            return _progress
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCircle()
    }

    @IBAction func buttonPressed(sender: UIButton) {
        onButtonPressed?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addCircle()
    }
    
    private func addCircle() {
        roundView?.removeFromSuperview()
        roundView = UIView(frame: CGRect(x:padding, y:padding, width: frame.width-padding*2, height: frame.height-padding*2))
        circleShape = CAShapeLayer()
        guard let roundView = roundView, let circleShape = circleShape else { return }
        roundView.layer.cornerRadius = roundView.frame.size.width / 2
        let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2, y: roundView.frame.size.height / 2),
                                      radius: roundView.frame.size.width / 2,
                                      startAngle: CGFloat(-0.5 * .pi),
                                      endAngle: CGFloat(1.5 * .pi),
                                      clockwise: true)
        circleShape.path = circlePath.cgPath
        circleShape.strokeColor = UIColor.white.cgColor
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = stroke
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = 1 - progress
        roundView.layer.addSublayer(circleShape)
        addSubview(roundView)
        self.roundView = roundView
    }
    
}
