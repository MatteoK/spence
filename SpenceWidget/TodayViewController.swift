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
    case dailySpending
    
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
        registerCells()
        updateUI()
    }
    
    private func registerCells() {
        registerCell(nibName: SpendingButtonCell.nibName, reuseIdentifier: .button)
        registerCell(nibName: EnqueuedAmountCell.nibName, reuseIdentifier: .enqueuedAmount)
        registerCell(nibName: ProgressBarCell.nibName, reuseIdentifier: .progressBar)
        registerCell(nibName: DailySpendingCell.nibName, reuseIdentifier: .dailySpending)
    }
    
    private func registerCell(nibName: String, reuseIdentifier: ReuseIdentifier) {
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        updateProgressBar()
        refreshDailySpendingCell()
        refreshMonthlySpendingCell()
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
        timer.start(duration: 5.0) { [weak self] state in
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
        hideCancelButton { [weak self] in
            self?.updateCancelButton(progress: 0)
        }
        updateUI()
    }
    
    fileprivate func cancel() {
        timer.cancel()
        amountQueue.clear()
        clearValueLabel()
        hideCancelButton()
    }
    
    private func hideCancelButton(completion: (()->Void)? = nil) {
        setCancelButtonVisible(value: false) {
            completion?()
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
    
    private func updateProgressBar() {
        progressBarCell()?.progressBar.progress = localRepository.percentSpentToday
    }
    
    private func dailySpendingCell() -> DailySpendingCell? {
        return self.cell(with: .dailySpending) as? DailySpendingCell
    }
    
    private func refreshDailySpendingCell() {
        dailySpendingCell()?.titleLabel.text = "TODAY"
        dailySpendingCell()?.spendingLabel.text = valueTextWithCurrency(value: localRepository.todaysSpendings)
        dailySpendingCell()?.budgetLabel.text = "of \(Int(localRepository.todaysBudget))"
    }
    
    private func refreshMonthlySpendingCell() {
        monthlySpendingCell()?.titleLabel.text = "MONTH"
        monthlySpendingCell()?.spendingLabel.text = valueTextWithCurrency(value: localRepository.thisMonthsSpendings)
        monthlySpendingCell()?.budgetLabel.text = "of \(Int(localRepository.monthlyBudget))"
    }
    
    private func monthlySpendingCell() -> DailySpendingCell? {
        return self.cell(with: .monthlySpending) as? DailySpendingCell
    }
    
    private func valueTextWithCurrency(value: Float) -> String {
        return "\(localRepository.currency.symbol) \(Int(value))"
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
        case .dailySpending:
            return dailySpendingCell(at: indexPath)
        case .monthlySpending:
            return dailySpendingCell(at: indexPath)
        }
    }
    
    fileprivate func cellType(at indexPath: IndexPath) -> CellType {
        return viewModel.sections[indexPath.section].cells[indexPath.row]
    }
    
    private func buttonCell(with amount: ButtonAmount, at indexPath: IndexPath) -> SpendingButtonCell {
        let cell: SpendingButtonCell = dequeueCell(reuseIdentifier: .button, at: indexPath)
        cell.spendingButton.setTitle("\(Int(amount.value))", for: .normal)
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
    
    private func dailySpendingCell(at indexPath: IndexPath) -> DailySpendingCell {
        return dequeueCell(reuseIdentifier: .dailySpending, at: indexPath)
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
        case .dailySpending, .monthlySpending:
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
