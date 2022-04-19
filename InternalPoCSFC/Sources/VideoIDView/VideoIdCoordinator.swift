//
//  VideoIdCoordinator.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 23/3/22.
//

import Foundation
import UIKit

final class VideoIdCoordinator{
    
    static func view(delegate: VideoIdViewControllerDelegate) -> UIViewController{
        let vc = VideoIdViewController()
        vc.delegate = delegate
        return vc
    }
}
