//
//  ExpenseListWireframe.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class ExpenseListWireframe {
    
    let view: ExpenseListViewController
    let presenter: ExpenseListPresenter
    
    init() {
        let view = ExpenseListWireframe.instantiateViewController()
        let presenter = ExpenseListPresenter(view: view)
        view.presenter = presenter
        self.view = view
        self.presenter = presenter
    }
    
    private static func instantiateViewController() -> ExpenseListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return ExpenseListViewController.instantiate(from: storyboard)
    }
    
}
