//
//  SpendingListWireframe.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class SpendingListWireframe {
    
    let view: SpendingListViewController
    let presenter: SpendingListPresenter
    
    init() {
        let view = SpendingListWireframe.instantiateViewController()
        let presenter = SpendingListPresenter(view: view)
        view.presenter = presenter
        self.view = view
        self.presenter = presenter
    }
    
    private static func instantiateViewController() -> SpendingListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return SpendingListViewController.instantiate(from: storyboard)
    }
    
}
