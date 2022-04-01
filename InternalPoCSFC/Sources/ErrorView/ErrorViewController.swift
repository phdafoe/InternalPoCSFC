//
//  ErrorViewController.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 28/3/22.
//

import UIKit

protocol ErrorViewControllerDelegate: AnyObject {
    func dismissErrorVC(_ viewController: UIViewController, isDismiss: Bool)
}

class ErrorViewController: UIViewController {
    
    // MARK: - Variables
    weak var delegate: ErrorViewControllerDelegate?
    
    // MARK: - IBActions
    @IBAction func finalizarACTION(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.dismissErrorVC(self, isDismiss: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
