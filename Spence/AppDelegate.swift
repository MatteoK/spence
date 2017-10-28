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
    let expenseListWireframe = ExpenseListWireframe()
    let overviewWireframe = OverviewWireframe()
    let homeWireframe = HomeWireframe()
    private var wasActiveBefore = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        (UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.pushViewController(homeWireframe.view, animated: false)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard wasActiveBefore else {
            wasActiveBefore = true
            return
        }
        NotificationCenter.default.post(name: NotificationNames.appDidBecomeActive, object: nil)
    }

}

