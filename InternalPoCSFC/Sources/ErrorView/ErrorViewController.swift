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
    var dataFlow: MessageDTO?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var messageLBL: UILabel!
    @IBOutlet weak var messageTwoLBL: UILabel!
    
    // MARK: - IBActions
    @IBAction func finalizarACTION(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.dismissErrorVC(self, isDismiss: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLBL.text = self.dataFlow?.title
        self.messageLBL.text = self.dataFlow?.message
        self.messageTwoLBL.text = self.dataFlow?.messageTwo
        // Do any additional setup after loading the view.
    }


}
