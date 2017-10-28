//
//  HomeWireframe.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class HomeWireframe {
    
    let overviewWireframe: OverviewWireframe
    let listWireframe: ExpenseListWireframe
    let view: HomeViewController
    
    init() {
        overviewWireframe = OverviewWireframe()
        listWireframe = ExpenseListWireframe()
        view = HomeWireframe.instantiateViewController()
        view.addChildren(overviewViewController: overviewWireframe.view, listViewController: listWireframe.view)
    }
    
    private static func instantiateViewController() -> HomeViewController {
        return HomeViewController.instantiate(from: UIStoryboard(name: "Main", bundle: nil))
    }
    
}
