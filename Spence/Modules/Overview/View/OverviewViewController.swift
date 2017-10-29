//
//  OverviewViewController.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

protocol IOverviewView: class {
    
    func show(viewModel: OverviewViewModel)
    func showBudgetPicker(viewModel: BudgetOptionsViewModel)
    
}

final class OverviewViewController: UIViewController, IOverviewView {
    
    weak var presenter: IOverviewPresenter?
    @IBOutlet weak var todayProgressBar: CircularProgressBar!
    @IBOutlet weak var thisMonthProgressBar: CircularProgressBar!
    @IBOutlet weak var hiddenTextField: UITextField!
    let pickerView = SpencePickerView()
    private var dimmer: UIView?
    
    override func viewDidLoad() {
        view.backgroundColor = .background
        configureProgressBars()
        configurePickerView()
        presenter?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidLoad()
    }
    
    private func configureProgressBars() {
        [todayProgressBar, thisMonthProgressBar].flatMap({$0}).forEach {
            $0.configure(backgroundColor: UIColor.black.withAlphaComponent(0.2))
        }
    }
    
    private func configurePickerView() {
        hiddenTextField.inputView = pickerView
        pickerView.onDidFinishPicking = { [weak self] index in
            self?.presenter?.didPickBudget(at: index)
            self?.hiddenTextField.resignFirstResponder()
        }
    }
    
    func show(viewModel: OverviewViewModel) {
        guard todayProgressBar != nil && thisMonthProgressBar != nil else { return }
        todayProgressBar.updateProgress(value: CGFloat(viewModel.todaysExpenseProgress), animated: true)
        thisMonthProgressBar.updateProgress(value: CGFloat(viewModel.thisMonthsExpenseProgress), animated: true)
        todayProgressBar.topLabel.text = viewModel.todaysExpenses
        todayProgressBar.bottomLabel.text = viewModel.todaysBudget
        thisMonthProgressBar.topLabel.text = viewModel.thisMonthsExpenses
        thisMonthProgressBar.bottomLabel.text = viewModel.monthlyBudget
    }
    
    func showBudgetPicker(viewModel: BudgetOptionsViewModel) {
        pickerView.items = viewModel.options
        pickerView.selectedIndex = viewModel.selectedIndex
        pickerView.currency = viewModel.currency
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        addDimmer()
        hiddenTextField.becomeFirstResponder()
    }
    
    func keyboardWillShow() {
        dimmer?.alpha = 1
    }
    
    func keyboardWillHide() {
        dimmer?.alpha = 0
    }
    
    func keyboardDidHide() {
        removeDimmer()
    }
    
    private func addDimmer() {
        guard let window = UIApplication.shared.windows.first else { return }
        self.dimmer?.removeFromSuperview()
        let dimmer = UIView()
        dimmer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimmer.frame.size = window.frame.size
        dimmer.alpha = 0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmerTapped(sender:)))
        dimmer.addGestureRecognizer(tapRecognizer)
        window.addSubview(dimmer)
        self.dimmer = dimmer
    }
    
    private func removeDimmer() {
        dimmer?.removeFromSuperview()
        dimmer = nil
    }

    @IBAction func changeBudgetButtonPressed(sender: UIButton) {
        presenter?.changeBudgetButtonPressed()
    }
    
    @objc private func dimmerTapped(sender: UITapGestureRecognizer) {
        hiddenTextField.resignFirstResponder()
    }
    
}

