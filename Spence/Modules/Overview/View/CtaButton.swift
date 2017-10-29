//
//  CtaButton.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

final class CtaButton: UIButton {
    
    enum Style {
        case normal
        case cta
    }
    
    var style: Style = .normal {
        didSet {
            backgroundColor = color()
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
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = color()
        }
    }
    
    private func color() -> UIColor {
        switch style {
        case .normal:
            return isHighlighted ?
                UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1) :
                .darkBackground
        case .cta:
            return isHighlighted ? .ctaActive : .cta
        }
    }
    
    private func construct() {
        backgroundColor = color()
        setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
}
