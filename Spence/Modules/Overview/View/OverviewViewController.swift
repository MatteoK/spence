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
    
    override func viewDidLoad() {
        view.backgroundColor = .backgroundColor
        configureProgressBars()
        configurePickerView()
        presenter?.viewDidLoad()
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
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        hiddenTextField.becomeFirstResponder()
    }

    @IBAction func changeBudgetButtonPressed(sender: UIButton) {
        presenter?.changeBudgetButtonPressed()
    }
    
}

