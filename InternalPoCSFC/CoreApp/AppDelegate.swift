//
//  AppDelegate.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 23/3/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    let appCore: AppCoreCoordinatorProtocol = AppCoreCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let windowUnw = self.window else { return false }
        self.appCore.initialVC(window: windowUnw)
        return true
    }



}

