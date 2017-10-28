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
    fileprivate var viewModel: ExpenseListViewModel?
    fileprivate let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        presenter?.viewDidLoad()
    }
    
    private func registerCells() {
        tableView.register(ExpenseListItemCell.nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func show(viewModel: ExpenseListViewModel) {
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
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = SectionHeaderView.fromNib as? SectionHeaderView else { return nil }
        view.titleLabel.text = viewModel?.sections[section].title
        return view
    }
    
}

extension ExpenseListViewController: UITableViewDelegate {}
