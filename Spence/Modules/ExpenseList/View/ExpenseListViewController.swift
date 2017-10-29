//
//  ExpenseListViewController.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

protocol IExpenseListView: class {
    
    func show(viewModel: ExpenseListViewModel)
    
}

final class ExpenseListViewController: UIViewController, IExpenseListView {
    
    weak var presenter: IExpenseListPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleBar: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    fileprivate var viewModel: ExpenseListViewModel?
    fileprivate let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBar.backgroundColor = .background
//        titleBar.layer.shadowOpacity = 1
//        titleBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        titleBar.layer.shadowRadius = 2
//        titleBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        registerCells()
        presenter?.viewDidLoad()
    }
    
    private func registerCells() {
        tableView.register(ExpenseListItemCell.nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func show(viewModel: ExpenseListViewModel) {
        guard tableView != nil else { return }
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
}

extension ExpenseListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel!.sections[section]
        return section.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel!.sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ExpenseListItemCell
        cell.timeLabel.text = item.date
        cell.valueLabel.text = item.value
        cell.currencyLabel.text = item.currency
        cell.backgroundColor = .clear
        cell.showsLines = shouldShowSeparatorLines(at: indexPath)
        return cell
    }
    
    private func shouldShowSeparatorLines(at indexPath: IndexPath) -> Bool {
        guard let viewModel = self.viewModel else { return false }
        let isLastSection = indexPath.section == viewModel.sections.count - 1
        let isLastElementInSection = indexPath.row == viewModel.sections[indexPath.section].items.count - 1
        return isLastSection || !isLastElementInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = SectionHeaderView.fromNib as? SectionHeaderView else { return nil }
        view.titleLabel.text = viewModel?.sections[section].title
        return view
    }
    
}

extension ExpenseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        deleteItem(at: indexPath)
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        presenter?.deleteButtonPressedForItem(section: indexPath.section, row: indexPath.row)
    }
    
}
