//
//  RoundButton.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    var blurView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    func construct() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        addExpandedSubview(view: blurView)
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        blurView.isUserInteractionEnabled = false
        blurView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.layer.cornerRadius = frame.size.height / 2
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1
        }
    }
    
}
