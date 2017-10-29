//
//  PickerViewContainer.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/29/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class PickerViewContainer: UIView {
    
    private let pickerView: UIView
    private let doneButton = CtaButton()
    
    var onDoneButtonPressed: (() -> Void)?
    
    init(view: UIView) {
        self.pickerView = view
        super.init(frame: CGRect.zero)
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func construct() {
        backgroundColor = .background
        addPickerView()
        addDoneButton()
        addShadow()
    }
    
    private func addPickerView() {
        addExpandedSubview(view: pickerView, insets: UIEdgeInsets(top: 34, left: 0, bottom: 0, right: 0))
    }
    
    private func addDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.style = .cta
        addSubview(doneButton)
        addConstraints([
            .equalConstraint(from: doneButton, to: self, attribute: .trailing, constant: -8),
            .equalConstraint(from: doneButton, to: self, attribute: .top, constant: 8),
            .absoluteConstraint(view: doneButton, attribute: .height, constant: 34)
            ])
        doneButton.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func addShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: -1)
    }
    
    func doneButtonPressed(sender: UIButton) {
        onDoneButtonPressed?()
    }
    
}
