//
//  HomeViewController.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
    
    func addChildren(overviewViewController: OverviewViewController, listViewController: ExpenseListViewController) {
        addChild(viewController: overviewViewController)
        addChild(viewController: listViewController)
        overviewViewController.view.translatesAutoresizingMaskIntoConstraints = false
        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
        overviewViewController.view.backgroundColor = .clear
        listViewController.view.backgroundColor = .clear
        view.addConstraints([
            .equalConstraint(from: overviewViewController.view, to: view, attribute: .leading),
            .equalConstraint(from: overviewViewController.view, to: view, attribute: .top),
            .equalConstraint(from: overviewViewController.view, to: view, attribute: .trailing),
            .absoluteConstraint(view: overviewViewController.view, attribute: .height, constant: 300),
            NSLayoutConstraint(item: listViewController.view, attribute: .top, relatedBy: .equal, toItem: overviewViewController.view, attribute: .bottom, multiplier: 1, constant: 40),
            .equalConstraint(from: listViewController.view, to: view, attribute: .leading),
            .equalConstraint(from: listViewController.view, to: view, attribute: .trailing),
            .equalConstraint(from: listViewController.view, to: view, attribute: .bottom)
        ])
    }
    
    func addChild(viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
}

