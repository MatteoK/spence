//
//  CircleView.swift
//  ArcView
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

final class CircleView: UIView {
    
    private struct Config {
        
        let stroke: CGFloat
        let shadowColor: UIColor
        let color: UIColor
        let shadowRadius: CGFloat
        let progress: CGFloat
        
        static let defaults = Config(stroke: 10,
                                     shadowColor: UIColor.black.withAlphaComponent(0.5),
                                     color: .blue,
                                     shadowRadius: 2,
                                     progress: 1)
        
    }
    
    private var baseView: UIView?
    private var shapeLayer: CAShapeLayer?
    
    private var config = Config.defaults
    
    func configure(stroke: CGFloat = Config.defaults.stroke,
                   shadowColor: UIColor = Config.defaults.shadowColor,
                   color: UIColor = Config.defaults.color,
                   shadowRadius: CGFloat = Config.defaults.shadowRadius,
                   progress: CGFloat = Config.defaults.progress)
    {
        config = Config(stroke: stroke, shadowColor: shadowColor, color: color, shadowRadius: shadowRadius, progress: progress)
        applyConfig()
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
        recreateCircle()
    }
    
    private func recreateCircle() {
        let baseView = createNewBaseView()
        let circleShape = self.circleShape(around: baseView)
        baseView.layer.addSublayer(circleShape)
        addSubview(baseView)
        baseView.isUserInteractionEnabled = false
        self.baseView = baseView
        self.shapeLayer = circleShape
        applyConfig()
    }
    
    private func createNewBaseView() -> UIView {
        baseView?.removeFromSuperview()
        let view = UIView(frame: CGRect(
            x:config.stroke/2,
            y:config.stroke/2,
            width: frame.width - config.stroke,
            height: frame.height - config.stroke)
        )
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = view.frame.size.width / 2
        return view
    }
    
    private func circleShape(around view: UIView) -> CAShapeLayer {
        let circlePath = self.circlePath(around: view)
        let shape = CAShapeLayer()
        shape.path = circlePath.cgPath
        shape.lineCap = kCALineCapRound
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeStart = 0.0
        shape.shadowOpacity = 1
        shape.shadowOffset = CGSize.zero
        return shape
    }
    
    private func applyConfig() {
        shapeLayer?.shadowColor = config.shadowColor.cgColor
        shapeLayer?.shadowRadius = config.shadowRadius
        shapeLayer?.strokeEnd = config.progress
        shapeLayer?.lineWidth = config.stroke
        shapeLayer?.strokeColor = config.color.cgColor
    }
    
    private func circlePath(around view: UIView) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint (x: view.frame.size.width / 2, y: view.frame.size.height / 2),
                            radius: view.frame.size.width / 2,
                            startAngle: CGFloat(-0.5 * .pi),
                            endAngle: CGFloat(1.5 * .pi),
                            clockwise: true)
    }
    
    var previousFrame: CGRect?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if frame != previousFrame {
            previousFrame = frame
            recreateCircle()
        }
    }
    
}

