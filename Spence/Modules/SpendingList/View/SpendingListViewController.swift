//
//  SpendingListViewController.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

protocol ISpendingListView: class {
    
    func show(viewModel: SpendingListViewModel)
    
}

final class SpendingListViewController: UIViewController, ISpendingListView {
    
    weak var presenter: ISpendingListPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var viewModel: SpendingListViewModel?
    fileprivate let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        presenter?.viewDidLoad()
    }
    
    private func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func show(viewModel: SpendingListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
}

extension SpendingListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel!.sections[section]
        return section.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel!.sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(item.date) - \(item.value)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.sections[section].title
    }
    
}

extension SpendingListViewController: UITableViewDelegate {}
