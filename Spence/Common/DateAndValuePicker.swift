//
//  DateAndValuePicker.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/29/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

private final class TextField: UITextField {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
}

private final class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var onDigitInput: ((Int) -> Void)?
    var onDelete: (() -> Void)?
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isDigit {
            onDigitInput?(Int(string)!)
        } else {
            onDelete?()
        }
        return false
    }
    
}

private final class SelectableLabel: UILabel {
    
    var onSelect: (() -> Void)?
    let insets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
    
    var selected = false {
        didSet {
            updateStyle()
            if selected {
                onSelect?()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        construct()
    }
    
    private func construct() {
        setupStyle()
        addTapRecognizer()
        isUserInteractionEnabled = true
    }
    
    private func setupStyle() {
        layer.borderColor = UIColor.cta.cgColor
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    private func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tapRecognized() {
        selected = true
    }
    
    private func updateStyle() {
        if selected {
            layer.borderWidth = 2
        } else {
            layer.borderWidth = 0
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let original = super.intrinsicContentSize
        let calculatedWidth = original.width + insets.left + insets.right
        let minWidth: CGFloat = 0
        let width = max(minWidth, calculatedWidth)
        return CGSize(width: width, height: original.height + insets.top + insets.bottom)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: self.insets.left, bottom: 0, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override init(frame: CGRect) { fatalError() }
    
}

final class InputAccessoryView: UIView {
    
    fileprivate let valueLabel = SelectableLabel()
    fileprivate let dateLabel = SelectableLabel()
    fileprivate let doneButton = CtaButton()
    fileprivate let valueDescriptionLabel = UILabel()
    
    var onDoneButtonPressed: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        construct()
    }
    
    private func construct() {
        backgroundColor = .keyboardButton
        addShadow()
        setupValueDescriptionLabel()
        setupValueLabel()
        setupDoneButton()
        setupDateLabel()
    }
    
    private func addShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowOpacity = 1
    }
    
    private func setupValueDescriptionLabel() {
        valueDescriptionLabel.textColor = .white
        valueDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        valueDescriptionLabel.alpha = 0.4
        addSubview(valueDescriptionLabel)
        addConstraints([
            .equalConstraint(from: valueDescriptionLabel, to: self, attribute: .leading, constant: 16),
            .equalConstraint(from: valueDescriptionLabel, to: self, attribute: .centerY)
            ])
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(valueDescriptionTapRecognized))
        valueDescriptionLabel.addGestureRecognizer(tapRecognizer)
        valueDescriptionLabel.isUserInteractionEnabled = true
    }
    
    @objc private func valueDescriptionTapRecognized() {
        valueLabel.selected = true
    }
    
    private func setupValueLabel() {
        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textColor = .white
        addConstraints([
            .attaching(view: valueLabel, attribute: .leading, to: valueDescriptionLabel, attribute: .trailing, constant: 8),
            .equalConstraint(from: valueLabel, to: self, attribute: .centerY),
            .absoluteConstraint(view: valueLabel, attribute: .height, constant: 34),
            ])
    }
    
    private func setupDoneButton() {
        doneButton.style = .cta
        doneButton.setTitle("Done", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(doneButton)
        addConstraints([
            .equalConstraint(from: doneButton, to: self, attribute: .trailing, constant: -16),
            .equalConstraint(from: doneButton, to: self, attribute: .centerY),
            .absoluteConstraint(view: doneButton, attribute: .height, constant: 34),
            ])
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.white
        addConstraints([
            .attaching(view: dateLabel, attribute: .trailing, to: doneButton, attribute: .leading, constant: -16),
            .equalConstraint(from: dateLabel, to: self, attribute: .centerY),
            .absoluteConstraint(view: dateLabel, attribute: .height, constant: 34),
            ])
    }
    
    @objc private func doneButtonPressed() {
        onDoneButtonPressed?()
    }
    
    private override init(frame: CGRect) { fatalError() }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

class DateAndValuePicker {
    
    private let textField = TextField()
    private let textFieldDelegate = TextFieldDelegate()
    private let inputAccessoryView = InputAccessoryView()
    private let datePicker = UIDatePicker()
    private var isVisible = false
    private var isDismissing = false
    private var date = Date()
    private var dimmer: UIView?
    private var wasPrefilled = false
    
    var isDatePickingEnabled = true {
        didSet {
            inputAccessoryView.dateLabel.isHidden = !isDatePickingEnabled
        }
    }
    
    var onFinishPicking: ((Int, Date) -> Void)?
    var onCancel: (() -> Void)?
    
    private var value: String = "0" {
        didSet {
            updateValueLabel()
        }
    }
    
    func prefill(value: Int) {
        self.value = "\(value)"
        wasPrefilled = true
    }
    
    init() {
        setupTextField()
        setupInputAccessoryView()
        updateValueLabel()
        updateDateLabel()
        subscribeKeyboardNotifications()
        setupDatePicker()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTextField() {
        textField.text = " "
        textField.keyboardType = .numberPad
        textField.keyboardAppearance = .dark
        textField.delegate = textFieldDelegate
        textFieldDelegate.onDigitInput = { [weak self] digit in
            self?.add(digit: digit)
        }
        textFieldDelegate.onDelete = { [weak self] in
            self?.deleteDigit()
        }
    }
    
    private func add(digit: Int) {
        if wasPrefilled {
            value = "\(digit)"
            wasPrefilled = false
        } else if value == "0" {
            if digit != 0 {
                value = "\(digit)"
            }
        } else {
            value = "\(value)\(digit)"
        }
    }
    
    private func deleteDigit() {
        if wasPrefilled {
            value = "0"
            wasPrefilled = false
        } else if value.characters.count == 1 {
            if value != "0" {
                value = "0"
            }
        } else {
            value = value.substring(to: value.index(before: value.endIndex))
        }
    }
    
    private func setupInputAccessoryView() {
        inputAccessoryView.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        textField.inputAccessoryView = inputAccessoryView
        inputAccessoryView.valueLabel.selected = true
        inputAccessoryView.valueDescriptionLabel.text = Currency.selected.symbol
        inputAccessoryView.dateLabel.onSelect = { [weak self] in
            self?.inputAccessoryView.valueLabel.selected = false
            self?.switchToDatePicker()
        }
        inputAccessoryView.valueLabel.onSelect = { [weak self] in
            self?.inputAccessoryView.dateLabel.selected = false
            self?.switchToKeyboard()
        }
        inputAccessoryView.onDoneButtonPressed = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.onFinishPicking?(Int(strongSelf.value)!, strongSelf.date)
            strongSelf.dismiss()
        }
    }
    
    private func updateValueLabel() {
        inputAccessoryView.valueLabel.text = value
    }
    
    private func updateDateLabel() {
        inputAccessoryView.dateLabel.text = string(from: date)
    }
    
    private func string(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM. HH:mm"
        return dateFormatter.string(from:date)
    }
    
    private func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: .UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: .UIKeyboardWillHide,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide(notification:)),
            name: .UIKeyboardDidHide,
            object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard !isVisible, let keyboardHeight = notification.getKeyboardHeight else { return }
        let height = max(keyboardHeight, 200)
        datePicker.frame.size.height = height - 50
        dimmer?.alpha = 1
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard isDismissing else { return }
        dimmer?.alpha = 0
    }
    
    @objc private func keyboardDidHide(notification: Notification) {
        guard isDismissing else { return }
        dimmer?.removeFromSuperview()
        dimmer = nil
        isDismissing = false
    }
    
    func present() {
        UIApplication.shared.windows.first?.addSubview(textField)
        prepareDimmer()
        textField.becomeFirstResponder()
        isVisible = true
    }
    
    func dismiss() {
        isDismissing = true
        textField.resignFirstResponder()
        textField.removeFromSuperview()
    }
    
    private func prepareDimmer() {
        guard let window = UIApplication.shared.windows.first else { return }
        let dimmer = UIView()
        dimmer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimmer.frame.size = window.frame.size
        dimmer.alpha = 0
        window.addSubview(dimmer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmerTapped))
        dimmer.addGestureRecognizer(tapRecognizer)
        self.dimmer = dimmer
    }
    
    private func switchToDatePicker() {
        textField.resignFirstResponder()
        textField.inputView = datePicker
        datePicker.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        textField.becomeFirstResponder()
    }
    
    private func switchToKeyboard() {
        textField.resignFirstResponder()
        textField.inputView = nil
        textField.becomeFirstResponder()
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc private func datePickerValueChanged() {
        date = datePicker.date
        updateDateLabel()
    }
    
    @objc private func dimmerTapped() {
        dismiss()
        onCancel?()
    }
    
}

private extension String {
    
    var isDigit: Bool {
        return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(self)
    }
    
}
