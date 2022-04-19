//
//  ErrorCoordinator.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 28/3/22.
//

import Foundation
import UIKit

final class ErrorCoordinator {
    
    static func view(delegate: ErrorViewControllerDelegate? = nil, dto: MessageDTO? = nil) -> UIViewController {
        let vc = ErrorViewController()
        vc.delegate = delegate
        vc.dataFlow = dto
        return vc
    }
}
struct MessageDTO{
    var title: String
    var message: String
    var messageTwo: String
}


