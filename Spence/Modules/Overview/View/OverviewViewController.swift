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
    
}

final class OverviewViewController: UIViewController, IOverviewView {
    
    weak var presenter: IOverviewPresenter?
    @IBOutlet weak var todayProgressBar: CircularProgressBar!
    @IBOutlet weak var thisMonthProgressBar: CircularProgressBar!
    private var picker: DateAndValuePicker?
    private var viewModel: OverviewViewModel?
    
    override func viewDidLoad() {
        view.backgroundColor = .background
        configureProgressBars()
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
    
    func show(viewModel: OverviewViewModel) {
        self.viewModel = viewModel
        guard todayProgressBar != nil && thisMonthProgressBar != nil else { return }
        todayProgressBar.updateProgress(value: CGFloat(viewModel.todaysExpenseProgress), animated: true)
        thisMonthProgressBar.updateProgress(value: CGFloat(viewModel.thisMonthsExpenseProgress), animated: true)
        todayProgressBar.topLabel.text = viewModel.todaysExpenses
        todayProgressBar.bottomLabel.text = viewModel.todaysBudget
        thisMonthProgressBar.topLabel.text = viewModel.thisMonthsExpenses
        thisMonthProgressBar.bottomLabel.text = viewModel.monthlyBudget
    }

    @IBAction func changeBudgetButtonPressed(sender: UIButton) {
        guard let viewModel = self.viewModel else { return }
        picker = DateAndValuePicker()
        picker?.isDatePickingEnabled = false
        picker?.prefill(value: viewModel.monthlyBudgetValue)
        picker?.onFinishPicking = { [weak self] value, _ in
            self?.presenter?.changeBudgetSelected(value: value)
            self?.picker = nil
        }
        picker?.present()
    }
    
}

