//
//  SpencePickerView.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

final class SpencePickerView: UIView {
    
    private let pickerView = UIPickerView()
    private let doneButton = CtaButton()
    var items: [String] = []
    var selectedIndex = 0 {
        didSet {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }
    
    var onDidFinishPicking: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        construct()
    }
    
    private func construct() {
        backgroundColor = .darkBackground
        addPickerView()
        addDoneButton()
    }
    
    private func addPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        addExpandedSubview(view: pickerView, insets: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
    }
    
    private func addDoneButton() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        addSubview(doneButton)
        addConstraints([
            .equalConstraint(from: doneButton, to: self, attribute: .trailing, constant: -8),
            .equalConstraint(from: doneButton, to: self, attribute: .top, constant: 8),
            .absoluteConstraint(view: doneButton, attribute: .height, constant: 34)
        ])
        doneButton.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
    }
    
    func doneButtonPressed(sender: UIButton) {
        onDidFinishPicking?(pickerView.selectedRow(inComponent: 0))
    }
    
}

extension SpencePickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
}

extension SpencePickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(
            string: items[row],
            attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
}
