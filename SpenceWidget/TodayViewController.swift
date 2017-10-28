//
//  TodayViewController.swift
//  SpenceWidget
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit
import NotificationCenter

enum Amount: Int {
    
    case one, three, five
    
    var value: Float {
        switch self {
        case .one:
            return 1
        case .three:
            return 3
        case .five:
            return 5
        }
    }
    
}

private enum ReuseIdentifier: String {
    
    case button
    case enqueuedAmount
    case progressBar
    case dailyExpenses
    
}

private struct sizes {
    
    static let buttonWidth: CGFloat = 40
    static let buttonHeight: CGFloat = 40
    static let buttonMargin: CGFloat = 8
    static let inset: CGFloat = 15
    
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var localRepository: ILocalRepository = LocalRepository()
    var timer: IQueueTimer = QueueTimer()
    var amountQueue: IAmountQueue = AmountQueue()
    fileprivate let viewModel = ViewModel.create(showButtons: false)

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        registerCells()
        updateUI()
    }
    
    private func registerCells() {
        registerCell(nib: ExpenseButtonCell.nib, reuseIdentifier: .button)
        registerCell(nib: EnqueuedAmountCell.nib, reuseIdentifier: .enqueuedAmount)
        registerCell(nib: ProgressBarCell.nib, reuseIdentifier: .progressBar)
        registerCell(nib: DailyExpensesCell.nib, reuseIdentifier: .dailyExpenses)
    }
    
    private func registerCell(nib: UINib, reuseIdentifier: ReuseIdentifier) {
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        commitOngoingExpenseTimers()
    }
    
    private func commitOngoingExpenseTimers() {
        if timer.isActive {
            timer.cancel()
            commit()
        }
    }
    
    private func updateUI(animated: Bool = false) {
        updateProgressBar(animated: animated)
        refreshDailyExpensesCell()
        refreshMonthlyExpensesCell()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateUI()
        completionHandler(NCUpdateResult.newData)
    }
    
    fileprivate func enqueue(amount: Float) {
        amountQueue.enqueue(amount: amount)
        if timer.isActive {
            timer.restart()
        } else {
            startTimer()
        }
        refreshValueLabel()
    }
    
    private func startTimer() {
        timer.start(duration: 2.0) { [weak self] state in
            guard let strongSelf = self else { return }
            switch state {
            case .start:
                strongSelf.showCancelButton()
            case .ongoing(progress: let progress):
                strongSelf.updateCancelButton(progress: CGFloat(progress))
            case .done:
                strongSelf.commit()
            }
        }
    }
    
    private func commit() {
        amountQueue.commit()
        hideCancelButton()
        updateUI(animated: true)
    }
    
    fileprivate func cancel() {
        timer.cancel()
        amountQueue.clear()
        hideCancelButton()
    }
    
    private func hideCancelButton() {
        setCancelButtonVisible(value: false) { [weak self] in
            self?.updateCancelButton(progress: 0)
        }
    }
    
    private func showCancelButton(completion: (()->Void)? = nil) {
        setCancelButtonVisible(value: true) {
            completion?()
        }
    }
    
    private func setCancelButtonVisible(value: Bool, completion: (()->Void)? = nil) {
        guard let indexPath = self.indexPath(for: .progressBar), let cell = self.collectionView.cellForItem(at: indexPath) as? ProgressBarCell else { return }
        cell.setShowButtonsEnabled(value: value, animated: true) {
            completion?()
        }
    }
    
    fileprivate func clearValueLabel() {
        valueLabel()?.text = ""
    }
    
    private func refreshValueLabel() {
        updateValueLabel(with: amountQueue.enqueuedAmount)
    }
    
    private func updateValueLabel(with value: Float) {
        valueLabel()?.text = valueTextWithCurrency(value: value)
    }
    
    private func cancelButton() -> CancelButton? {
        return progressBarCell()?.cancelButton
    }
    
    private func valueLabel() -> UILabel? {
        return progressBarCell()?.valueLabel
    }
    
    private func updateCancelButton(progress: CGFloat) {
        progressBarCell()?.cancelButton.progress = progress
    }
    
    private func progressBarCell() -> ProgressBarCell? {
        return self.cell(with: .progressBar) as? ProgressBarCell
    }
    
    private func updateProgressBar(animated: Bool = false) {
        let block = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.progressBarCell()?.progressBar.progress = strongSelf.localRepository.percentSpentToday
            strongSelf.progressBarCell()?.layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: 0.3) { [weak self] in
                block()
            }
        } else {
            block()
        }
    }
    
    private func dailyExpensesCell() -> DailyExpensesCell? {
        return self.cell(with: .dailyExpenses) as? DailyExpensesCell
    }
    
    private func refreshDailyExpensesCell() {
        dailyExpensesCell()?.titleLabel.text = "TODAY"
        dailyExpensesCell()?.expenseLabel.text = valueTextWithCurrency(value: localRepository.todaysExpenses)
        dailyExpensesCell()?.budgetLabel.text = "of \(Int(localRepository.todaysBudget))"
    }
    
    private func refreshMonthlyExpensesCell() {
        monthlyExpensesCell()?.titleLabel.text = "MONTH"
        monthlyExpensesCell()?.expenseLabel.text = valueTextWithCurrency(value: localRepository.thisMonthsExpenses)
        monthlyExpensesCell()?.budgetLabel.text = "of \(Int(localRepository.monthlyBudget))"
    }
    
    private func monthlyExpensesCell() -> DailyExpensesCell? {
        return self.cell(with: .monthlyExpenses) as? DailyExpensesCell
    }
    
    private func valueTextWithCurrency(value: Float) -> String {
        return "\(Currency.selected.symbol) \(Int(value))"
    }
    
}

extension TodayViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellType(at: indexPath) {
        case .button(let amount):
            return buttonCell(with: amount, at: indexPath)
        case .enqueuedAmount:
            return enqueuedAmountCell(at: indexPath)
        case .progressBar:
            return progressBarCell(at: indexPath)
        case .dailyExpenses:
            return dailyExpensesCell(at: indexPath)
        case .monthlyExpenses:
            return dailyExpensesCell(at: indexPath)
        }
    }
    
    fileprivate func cellType(at indexPath: IndexPath) -> CellType {
        return viewModel.sections[indexPath.section].cells[indexPath.row]
    }
    
    private func buttonCell(with amount: ButtonAmount, at indexPath: IndexPath) -> ExpenseButtonCell {
        let cell: ExpenseButtonCell = dequeueCell(reuseIdentifier: .button, at: indexPath)
        cell.expenseButton.setTitle("\(Int(amount.value))", for: .normal)
        cell.onButtonPressed = { [weak self] in
            self?.enqueue(amount: amount.value)
            self?.updateAmountCell()
        }
        return cell
    }
    
    private func enqueuedAmountCell(at indexPath: IndexPath) -> EnqueuedAmountCell {
        let cell: EnqueuedAmountCell = dequeueCell(reuseIdentifier: .enqueuedAmount, at: indexPath)
        cell.label.text = "\(Int(amountQueue.enqueuedAmount))"
        return cell
    }
    
    private func progressBarCell(at indexPath: IndexPath) -> ProgressBarCell {
        let cell: ProgressBarCell = dequeueCell(reuseIdentifier: .progressBar, at: indexPath)
        cell.onCancelButtonPressed = { [weak self] in
            self?.cancel()
        }
        return cell
    }
    
    private func dailyExpensesCell(at indexPath: IndexPath) -> DailyExpensesCell {
        return dequeueCell(reuseIdentifier: .dailyExpenses, at: indexPath)
    }
    
    private func dequeueCell<T>(reuseIdentifier: ReuseIdentifier, at indexPath: IndexPath) -> T {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier.rawValue, for: indexPath) as! T
    }
    
    private func updateAmountCell() {
        guard let indexPath = self.indexPath(for: .enqueuedAmount), let amountCell = collectionView.cellForItem(at: indexPath) as? EnqueuedAmountCell else { return }
        amountCell.label.text = "\(Int(amountQueue.enqueuedAmount))"
    }
    
    fileprivate func cell(with type: CellType) -> UICollectionViewCell? {
        guard let indexPath = self.indexPath(for: type) else { return nil }
        return collectionView.cellForItem(at: indexPath)
    }
    
    fileprivate func indexPath(for type: CellType) -> IndexPath? {
        for section in 0..<viewModel.sections.count {
            for row in 0..<viewModel.sections[section].cells.count {
                switch viewModel.sections[section].cells[row] {
                case type:
                    return IndexPath(row: row, section: section)
                default:
                    break
                }
            }
        }
        return nil
    }
    
}

extension TodayViewController: UICollectionViewDelegate {}

extension TodayViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellType(at: indexPath) {
        case .button:
            return CGSize(width: 40, height: 40)
        case .progressBar:
            return CGSize(width: collectionView.frame.width, height: 40)
        case .dailyExpenses, .monthlyExpenses:
            return CGSize(width: (collectionView.frame.width - buttonsWidth() - sizes.inset*2 - sizes.buttonMargin)/2, height: 60)
        default:
            return CGSize.zero
        }
    }
    
    private func buttonsWidth() -> CGFloat {
        return CGFloat(ButtonAmount.all.count) * sizes.buttonWidth + CGFloat(ButtonAmount.all.count) * sizes.buttonMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch viewModel.sections[section].type {
        case .top:
            return UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch viewModel.sections[section].type {
        case .top:
            return 0
        default:
            return sizes.buttonMargin
        }
    }
    
}
