//
//  OverviewWireframe.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

class OverviewWireframe {
    
    let view: OverviewViewController
    let presenter: OverviewPresenter
    
    init() {
        let view = OverviewWireframe.instantiateViewController()
        let presenter = OverviewPresenter(view: view)
        view.presenter = presenter
        self.view = view
        self.presenter = presenter
    }
    
    private static func instantiateViewController() -> OverviewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return OverviewViewController.instantiate(from: storyboard)
    }
    
}

