//
//  SpencePickerView.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class BudgetPickerView: UIView {
    
    private var pickerViewContainer: PickerViewContainer!
    private let pickerView = UIPickerView()
    private let currencyLabel = UILabel()
    var items: [String] = []
    
    var selectedIndex = 0 {
        didSet {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }
    
    var currency: String = "" {
        didSet {
            currencyLabel.text = currency
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
    
    func construct() {
        addPickerView()
        addCurrencyLabel()
    }
    
    private func addPickerView() {
        pickerViewContainer = PickerViewContainer(view: pickerView)
        pickerViewContainer.onDoneButtonPressed = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onDidFinishPicking?(strongSelf.pickerView.selectedRow(inComponent: 0))
        }
        pickerView.dataSource = self
        pickerView.delegate = self
        addExpandedSubview(view: pickerViewContainer)
    }
    
    private func addCurrencyLabel() {
        currencyLabel.font = UIFont.systemFont(ofSize: 20)
        currencyLabel.textColor = UIColor.white
        currencyLabel.alpha = 0.4
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currencyLabel)
        addConstraints([
            .equalConstraint(from: currencyLabel, to: pickerView, attribute: .centerX, constant: -30),
            .equalConstraint(from: currencyLabel, to: pickerView, attribute: .centerY)
        ])
    }
    
}

extension BudgetPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
}

extension BudgetPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = pickerView.frame.width/2-25
        return NSAttributedString(
            string: items[row],
            attributes: [
                NSForegroundColorAttributeName: UIColor.white,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
        )
    }
    
}
