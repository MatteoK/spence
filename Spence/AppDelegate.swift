//
//  AppDelegate.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var expenseListWireframe = ExpenseListWireframe()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        (UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.pushViewController(expenseListWireframe.view, animated: false)
        return true
    }

}

