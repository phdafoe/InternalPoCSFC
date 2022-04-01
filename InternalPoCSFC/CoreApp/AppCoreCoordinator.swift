//
//  AppCoreCoordinator.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 23/3/22.
//

import Foundation
import UIKit

protocol AppCoreCoordinatorProtocol{
    func initialVC(window: UIWindow)
}

final class AppCoreCoordinator{
    var currentVC = UIViewController()
}

extension AppCoreCoordinator: AppCoreCoordinatorProtocol {
    func initialVC(window: UIWindow) {
        self.currentVC = VideoIdCoordinator.view()
        window.rootViewController = self.currentVC
        window.makeKeyAndVisible()
    }
}
