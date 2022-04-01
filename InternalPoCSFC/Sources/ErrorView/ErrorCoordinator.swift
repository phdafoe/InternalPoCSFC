//
//  ErrorCoordinator.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 28/3/22.
//

import Foundation
import UIKit

final class ErrorCoordinator {
    
    static func view(delegate: ErrorViewControllerDelegate? = nil) -> UIViewController {
        let vc = ErrorViewController()
        vc.delegate = delegate
        return vc
    }
}
