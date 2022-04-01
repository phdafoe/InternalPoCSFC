//
//  ExitoCoordinator.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 28/3/22.
//

import Foundation
import UIKit

final class ExitoCoordinator {
    
    static func view(delegate: ExitoViewControllerDelegate? = nil) -> UIViewController {
        let vc = ExitoViewController()
        vc.delegate = delegate
        return vc
    }
}
