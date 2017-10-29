//
//  RoundButton.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    func construct() {
        backgroundColor = .cta
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1
        }
    }
    
}
